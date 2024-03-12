/***************************************************************
 * Copyright (c) 2020 Xilinx, Inc.  All rights reserved.
 * SPDX-License-Identifier: MIT
 ***************************************************************/

#ifndef __LIBDFX_H
#define __LIBDFX_H

#define DFX_NORMAL_EN			(0x00000000U)
#define DFX_EXTERNAL_CONFIG_EN		(0x00000001U)
#define DFX_ENCRYPTION_USERKEY_EN	(0x00000020U)

/* Error codes */
#define DFX_INVALID_PLATFORM_ERROR		(0x1U)
#define DFX_CREATE_PACKAGE_ERROR		(0x2U)
#define DFX_DUPLICATE_FIRMWARE_ERROR		(0x3U)
#define DFX_DUPLICATE_DTBO_ERROR		(0x4U)
#define DFX_READ_PACKAGE_ERROR			(0x5U)
#define DFX_AESKEY_READ_ERROR			(0x6U)
#define DFX_DMABUF_ALLOC_ERROR			(0x7U)
#define DFX_INVALID_PACKAGE_ID_ERROR		(0x8U)
#define DFX_GET_PACKAGE_ERROR			(0x9U)
#define DFX_FAIL_TO_OPEN_DEV_NODE		(0xAU)
#define DFX_IMAGE_CONFIG_ERROR			(0xBU)
#define DFX_DRIVER_CONFIG_ERROR			(0xCU)
#define DFX_NO_VALID_DRIVER_DTO_FILE		(0xDU)
#define DFX_DESTROY_PACKAGE_ERROR		(0xEU)
#define DFX_FAIL_TO_OPEN_BIN_FILE		(0xFU)
#define DFX_INSUFFICIENT_MEM			(0x10U)

int dfx_cfg_init(const char *dfx_package_path,
                  const char *devpath, unsigned long flags);
int dfx_cfg_load(int package_id);
int dfx_cfg_drivers_load(int package_id);
int dfx_cfg_remove(int package_id);
int dfx_cfg_destroy(int package_id);
int dfx_get_active_uid_list(int *buffer);
int dfx_get_meta_header(char *binfile, int *buffer, int buf_size);

#endif
