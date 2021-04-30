// © Copyright 2021 Xilinx, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/* k-Means accelerator Vitis HLS implementation */
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/* Max N (nodes) and K (centroids/clusters) values supported */
#define MAX_CENTROIDS 256
#define MAX_NODES     8192

/* Main k-means algorithm function */
int kmeans (
  volatile uint64_t *node_x_coords,
  volatile uint64_t *node_y_coords,
  volatile uint64_t *node_cluster_assignments,
  volatile uint64_t *centroid_x_coords,
  volatile uint64_t *centroid_y_coords,
  volatile uint64_t max_iterations,
  int n,
  int k
) {

  int converged = 0;
  int i, j;
  int min_dist_index;
  uint64_t centroid_dist;
  uint64_t min_dist;
  uint32_t current_iteration = 0;

  /* Arrays containing the updated centroid coordinates and numbers */
  uint64_t centroid_x_coords_next[MAX_CENTROIDS];
  uint64_t centroid_y_coords_next[MAX_CENTROIDS];
  uint16_t cluster_cardinality_next[MAX_CENTROIDS];

  /* Arrays containing the previous centroid coordinates */
  volatile uint64_t centroid_x_coords_prev[MAX_CENTROIDS];
  volatile uint64_t centroid_y_coords_prev[MAX_CENTROIDS];

  /* Stop conditions */
  while ((!converged) && (current_iteration < max_iterations)) {

    converged = 1;

    {

      /* Copy current centroids into temporary buffer for later comparison */
      memcpy((void*)centroid_x_coords_prev, (void*)centroid_x_coords, k*sizeof(uint64_t));
      memcpy((void*)centroid_y_coords_prev, (void*)centroid_y_coords, k*sizeof(uint64_t));

      /* Empty next round buffers */
      memset((void*)cluster_cardinality_next, 0, k*sizeof(uint64_t));
      memset((void*)centroid_x_coords_next, 0, k*sizeof(uint64_t));
      memset((void*)centroid_y_coords_next, 0, k*sizeof(uint64_t));

      /* For each node */
      for (i = 0; i < n; i++) {
        min_dist = 0xFFFFFFFFFFFFFFFF;
        min_dist_index = 0;

        for (j=0; j<k; j++) {

          /* Get distance from to each centroid */
          centroid_dist = (((
            node_x_coords[i]<centroid_x_coords[j]) ?
              (centroid_x_coords[j]-node_x_coords[i]) :
              (node_x_coords[i]-centroid_x_coords[j]))*((node_x_coords[i]<centroid_x_coords[j]) ?
                (centroid_x_coords[j]-node_x_coords[i]) :
                (node_x_coords[i]-centroid_x_coords[j]))) + (((node_y_coords[i]<centroid_y_coords[j]) ?
                  (centroid_y_coords[j]-node_y_coords[i]) :
                  (node_y_coords[i]-centroid_y_coords[j]))*((node_y_coords[i]<centroid_y_coords[j]) ?
                    (centroid_y_coords[j]-node_y_coords[i]) :
                    (node_y_coords[i]-centroid_y_coords[j])));

          if (centroid_dist < min_dist) {
              min_dist = centroid_dist;
              min_dist_index = j;
            }
        }

        /* Update node's cluster assignment */
        node_cluster_assignments[i] = min_dist_index;
        centroid_x_coords_next[min_dist_index] += node_x_coords[i];
        centroid_y_coords_next[min_dist_index] += node_y_coords[i];
        cluster_cardinality_next[min_dist_index] += 1;
      }

      /* Update centroid coordinates */
      for (i = 0; i < k; i++) {
#pragma HLS unroll
        if(cluster_cardinality_next[i]>0) {
            centroid_x_coords[i] = (centroid_x_coords_next[i]/cluster_cardinality_next[i]);
        }
      }
      for (i = 0; i < k; i++) {
#pragma HLS unroll
        if(cluster_cardinality_next[i]>0) {
            centroid_y_coords[i] = (centroid_y_coords_next[i]/cluster_cardinality_next[i]);
        }
      }
    }

    /* Check convergence (converged if no centroids coordinates have changed) */
    for (i = 0; i < k; i++) {
      if ((centroid_x_coords_prev[i] != centroid_x_coords[i]) || (centroid_x_coords_prev[i] != centroid_y_coords[i])) {
        converged = 0;
        break;
      }
    }

    current_iteration++;
  }

  return converged;
}


/* Top-level function for accelerator block */
void kmeans_top (
  volatile int n,
  volatile int k,
  volatile uint32_t control,
  volatile uint64_t *buf_ptr_node_x_coords,
  volatile uint64_t *buf_ptr_node_y_coords,
  volatile uint64_t *buf_ptr_node_cluster_assignments,
  volatile uint64_t *buf_ptr_centroid_x_coords,
  volatile uint64_t *buf_ptr_centroid_y_coords,
  volatile uint64_t *buf_ptr_intermediate_cluster_assignments,
  volatile uint64_t *buf_ptr_intermediate_centroid_x_coords,
  volatile uint64_t *buf_ptr_intermediate_centroid_y_coords,
  volatile uint64_t max_iterations,
  volatile uint64_t sub_iterations) {

#pragma HLS INTERFACE s_axilite port=return         bundle=cfg
#pragma HLS INTERFACE s_axilite port=n              bundle=cfg
#pragma HLS INTERFACE s_axilite port=k              bundle=cfg
#pragma HLS INTERFACE s_axilite port=control        bundle=cfg
#pragma HLS INTERFACE s_axilite port=max_iterations bundle=cfg
#pragma HLS INTERFACE s_axilite port=sub_iterations bundle=cfg

#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_node_x_coords                    bundle=mem
#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_node_y_coords                    bundle=mem
#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_node_cluster_assignments         bundle=mem
#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_centroid_x_coords                bundle=mem
#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_centroid_y_coords                bundle=mem
#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_intermediate_cluster_assignments bundle=mem
#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_intermediate_centroid_x_coords   bundle=mem
#pragma HLS INTERFACE m_axi depth=32 port=buf_ptr_intermediate_centroid_y_coords   bundle=mem

  uint64_t node_x_coords[MAX_NODES];
  uint64_t node_y_coords[MAX_NODES];
  uint64_t node_cluster_assignments[MAX_NODES];
  uint64_t centroid_x_coords[MAX_CENTROIDS];
  uint64_t centroid_y_coords[MAX_CENTROIDS];

#pragma HLS bind_storage variable=node_x_coords impl=uram type=ram_2p
#pragma HLS bind_storage variable=node_y_coords impl=uram type=ram_2p
#pragma HLS bind_storage variable=node_cluster_assignments impl=uram type=ram_2p

  int converged = 0;
  int current_iteration = 0;

  uint32_t intermediate_data_buf_offset = 0;
  uint32_t intermediate_writes_made = 0;

  size_t nodes_size = 0;
  size_t centroids_size = 0;

  nodes_size = n*sizeof(uint64_t);
  centroids_size = k*sizeof(uint64_t);

  /* Initial memory copy */
  memcpy(node_x_coords,            (const uint64_t*)buf_ptr_node_x_coords,             nodes_size);
  memcpy(node_y_coords,            (const uint64_t*)buf_ptr_node_y_coords,             nodes_size);
  memcpy(node_cluster_assignments, (const uint64_t*)buf_ptr_node_cluster_assignments,  nodes_size);
  memcpy(centroid_x_coords,        (const uint64_t*)buf_ptr_centroid_x_coords,         centroids_size);
  memcpy(centroid_y_coords,        (const uint64_t*)buf_ptr_centroid_y_coords,         centroids_size);

  while ((!converged) && (current_iteration < max_iterations)) {

    converged = kmeans(node_x_coords, node_y_coords, node_cluster_assignments, centroid_x_coords, centroid_y_coords, sub_iterations, n, k);
    intermediate_data_buf_offset = (intermediate_writes_made*(n+(2*k)))*sizeof(uint64_t);

		if ((control & 0x2) && (sub_iterations < max_iterations)) {
		  memcpy((uint64_t*)(buf_ptr_intermediate_cluster_assignments+intermediate_data_buf_offset), node_cluster_assignments, nodes_size);
		}
		if ((control & 0x1) && (sub_iterations < max_iterations)) {
		  memcpy((uint64_t*)(buf_ptr_intermediate_centroid_x_coords+intermediate_data_buf_offset), centroid_x_coords, centroids_size);
		  memcpy((uint64_t*)(buf_ptr_intermediate_centroid_y_coords+intermediate_data_buf_offset), centroid_y_coords, centroids_size);
		}

    current_iteration += sub_iterations;
    intermediate_writes_made++;
  }

  if (control & 0x4) {
	  memcpy((uint64_t*)buf_ptr_node_x_coords, node_x_coords, nodes_size);
	  memcpy((uint64_t*)buf_ptr_node_y_coords, node_y_coords, nodes_size);
  }
  if (control & 0x2) {
	  memcpy((uint64_t*)buf_ptr_node_cluster_assignments, node_cluster_assignments, nodes_size);
  }
  if (control & 0x1) {
	  memcpy((uint64_t*)buf_ptr_centroid_x_coords, centroid_x_coords, centroids_size);
	  memcpy((uint64_t*)buf_ptr_centroid_y_coords, centroid_y_coords, centroids_size);
  }

  return;
}
