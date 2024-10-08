# Thanks to Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)
TARGET_EXEC := main

# Compiler
CXX := clang++

BUILD_DIR := ./target
DEBUG_DIR := $(BUILD_DIR)/debug
RELEASE_DIR := $(BUILD_DIR)/release

SRC_DIRS := ./src
INC_DIRS := ./include
EXT_DIRS := ./external

# Find all the C and C++ files we want to compile
# Prepends BUILD_DIR and appends .o to every src file
# String substitution (suffix version without %).
SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')
OBJS := $(SRCS:%=$(DEBUG_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

# Same but for release version
OBJS_RELEASE := $(SRCS:%=$(RELEASE_DIR)/%.o)
DEPS_RELEASE := $(OBJS_RELEASE:.o=.d)

# Add a prefix to INC_DIRS.
INC_FLAGS := $(addprefix -I,$(INC_DIRS))
# Add a prefix to EXT_DIRS
EXT_FLAGS := $(addprefix -I,$(EXT_DIRS))

# CPP debug and release flags
CPPFLAGS := $(INC_FLAGS) -MMD -MP -O0 -g -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer -fno-inline -Wall -Wextra
CPPFLAGS_RELEASE := $(INC_FLAGS) -MMD -MP -O3 -flto -finline-functions -fomit-frame-pointer -fmerge-all-constants -fstrict-aliasing -march=native -mtune=native

# Linker flags
LDFLAGS_DEBUG := -fsanitize=address -fsanitize=undefined 
LDFLAGS_RELEASE := -flto

# The final build step.
$(DEBUG_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CXX) $(OBJS) $(LDFLAGS_DEBUG) -o $@ $(LDFLAGS)

# Build step for C source
$(DEBUG_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Build step for C++ source
$(DEBUG_DIR)/%.cpp.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

# The final build step for release builds
.PHONY: release
release: $(RELEASE_DIR)/$(TARGET_EXEC)

$(RELEASE_DIR)/$(TARGET_EXEC): $(OBJS_RELEASE)
	$(CXX) $(OBJS_RELEASE) $(LDFLAGS_RELEASE) -o $@ $(LDFLAGS)

# Build step for C source
$(RELEASE_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS_RELEASE) $(CFLAGS) -c $< -o $@

# Build step for C++ source
$(RELEASE_DIR)/%.cpp.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS_RELEASE) $(CXXFLAGS) -c $< -o $@

# Auxillary commands
.PHONY: clean rebuild rebuild-release run run-release

clean:
		@if [ -d "$(BUILD_DIR)" ]; then \
			rm -r $(BUILD_DIR); \
		fi

rebuild: clean $(DEBUG_DIR)/$(TARGET_EXEC)

rebuild-release: clean release

run: $(DEBUG_DIR)/$(TARGET_EXEC)
	@$(DEBUG_DIR)/$(TARGET_EXEC)

run-release: release
	@$(RELEASE_DIR)/$(TARGET_EXEC)

-include $(DEPS)
-include $(DEPS_RELEASE)
