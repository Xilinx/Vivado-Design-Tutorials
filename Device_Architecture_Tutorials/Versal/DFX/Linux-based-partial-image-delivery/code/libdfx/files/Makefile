APP = libdfx-app

# Add any other object files to this list below
APP_OBJS = libdfx-app.o

# Adding library
LDLIBS += -L<INSTALL_DIR>/Linux-based-partial-image-delivery/versal-dfx/project-spec/meta-user/recipes-apps/libdfx-app/files -Bstatic -ldfx

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) -o $@ $(APP_OBJS) $(LDFLAGS) $(LDLIBS)
clean:
	rm -f $(APP) *.o

