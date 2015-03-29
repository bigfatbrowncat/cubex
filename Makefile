APPLICATION_NAME = Cubex

ZETES_PATH = ../../zetes

include $(ZETES_PATH)/common-scripts/globals.mk

SRC = src
BIN = bin
OBJ = obj
LIB = lib

DEBUG_OPTIMIZE = -O0 -g

ifeq ($(UNAME), Darwin)	# OS X
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/darwin"
else ifeq ($(UNAME) $(ARCH), Linux x86_64)		# linux on PC
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/linux"
else ifeq ($(UNAME) $(ARCH), Linux armv6l)		# linux on Raspberry Pi
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/linux"
else ifeq ($(UNAME) $(ARCH), Linux armv7l)              # linux ARM v7
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/linux"
else ifeq ($(OS) $(ARCH), Windows_NT i686)		# Windows 32
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/win32"
else ifeq ($(OS) $(ARCH), Windows_NT x86_64)	# Windows 64
  PLATFORM_GENERAL_INCLUDES = -I"$(JAVA_HOME)/include" -I"$(JAVA_HOME)/include/win32"
endif

# Java platform agnostic
JAVA_SOURCE_PATH = $(SRC)/java
JAVA_FILES = $(shell if [ -d "$(JAVA_SOURCE_PATH)" ]; then cd $(JAVA_SOURCE_PATH); find . -type f -name \*.java | awk '{ sub(/.\//,"") }; 1'; fi )
JAVA_CLASSES = $(addprefix $(JAVA_CLASSPATH)/,$(addsuffix .class,$(basename $(JAVA_FILES))))

# Java platform specific
JAVA_PLATFORM_SPECIFIC_SOURCE_PATH = $(SRC)/$(PLATFORM_TAG)/java
JAVA_PLATFORM_SPECIFIC_FILES = $(shell if [ -d "$(JAVA_PLATFORM_SPECIFIC_SOURCE_PATH)" ]; then cd $(JAVA_PLATFORM_SPECIFIC_SOURCE_PATH); find . -type f -name \*.java | awk '{ sub(/.\//,"") }; 1'; fi)
JAVA_PLATFORM_SPECIFIC_CLASSES = $(addprefix $(JAVA_CLASSPATH)/,$(addsuffix .class,$(basename $(JAVA_PLATFORM_SPECIFIC_FILES))))

# C++ Platform agnostic
CPP_SOURCE_PATH = $(SRC)/cpp
CPP_FILES = $(shell cd $(CPP_SOURCE_PATH); find . -type f -name \*.cpp | awk '{ sub(/.\//,"") }; 1')
CPP_HEADER_FILES = $(addprefix $(CPP_SOURCE_PATH)/,$(shell cd $(CPP_SOURCE_PATH); find . -type f -name \*.h | awk '{ sub(/.\//,"") }; 1'))
CPP_OBJECTS = $(addprefix $(OBJECTS_PATH)/,$(addsuffix .o,$(basename $(CPP_FILES))))

# Target paths
LIBRARY_PATH = $(TARGET)/$(LIB)/$(PLATFORM_TAG)
OBJECTS_PATH = $(TARGET)/$(OBJ)/$(PLATFORM_TAG)
JAVA_LIBRARY_PATH = $(TARGET)/$(LIB)/java
JAVA_OBJECTS_PATH = $(TARGET)/$(OBJ)/java
JAVA_CLASSPATH = $(JAVA_OBJECTS_PATH)/classes

# Target names
LIBRARY_NAME = libcubex.a
JAVA_LIBRARY_NAME = cubex.jar
TOOLS_PATH = tools/$(PLATFORM_TAG)
PACKAGE_NAME = zetesfeet.zip
CUBEX_INCLUDES = $(shell find include/cubex -type f -name \*.h )

all: libcubex $(JUST_COPY_FILES_TARGET)
	@echo "*** $(APPLICATION_NAME) building process completed successfully. ***"
	@echo You can find the result in folders:
	@echo
	@echo "  $(realpath $(LIBRARY_PATH))"
	@echo "  $(realpath $(JAVA_LIBRARY_PATH))"
	@echo

# Other files that should just be copied to the target folder 
JUST_COPY_FILES = $(CUBEX_INCLUDES)
include ../../zetes/common-scripts/just_copy.mk

package: $(TARGET)/$(PACKAGE_NAME)

$(JAVA_CLASSPATH)/%.class: $(JAVA_SOURCE_PATH)/%.java
	@echo [$(APPLICATION_NAME)] Compiling $<...
	if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
	"$(JAVA_HOME)/bin/javac" -encoding utf8 -sourcepath "$(JAVA_SOURCE_PATH)" -classpath "$(JAVA_CLASSPATH)" -d "$(JAVA_CLASSPATH)" $<

$(JAVA_CLASSPATH)/%.class: $(JAVA_PLATFORM_SPECIFIC_SOURCE_PATH)/%.java
	@echo [$(APPLICATION_NAME)] Compiling platform specific $<...
	if [ ! -d "$(dir $@)" ]; then mkdir -p "$(dir $@)"; fi
	"$(JAVA_HOME)/bin/javac" -encoding utf8 -sourcepath "$(JAVA_PLATFORM_SPECIFIC_SOURCE_PATH)" -classpath "$(JAVA_CLASSPATH)" -d "$(JAVA_CLASSPATH)" $<

$(OBJECTS_PATH)/%.o: $(SRC)/cpp/%.cpp $(CPP_HEADER_FILES)
	@echo [$(APPLICATION_NAME)] Compiling $<...
	mkdir -p $(OBJECTS_PATH)
	g++ $(DEBUG_OPTIMIZE) $(PIC) -D_JNI_IMPLEMENTATION_ -c -Iinclude $(PLATFORM_GENERAL_INCLUDES) $< -o $@


libcubex: $(LIBRARY_PATH)/$(LIBRARY_NAME)
	
$(LIBRARY_PATH)/$(LIBRARY_NAME): $(CPP_OBJECTS)
	@echo [$(APPLICATION_NAME)] Constructing $@...
	mkdir -p $(LIBRARY_PATH);
	mkdir -p $(OBJECTS_PATH);
	mkdir -p $(JAVA_LIBRARY_PATH)

	# Making an object file from the java class library
	
	ar rvs $@ $(CPP_OBJECTS)

$(JAVA_LIBRARY_PATH)/$(JAVA_LIBRARY_NAME): $(CLASSPATHJAR) $(JAVA_CLASSES) $(JAVA_PLATFORM_SPECIFIC_CLASSES)
	@echo [$(APPLICATION_NAME)] Constructing $@...
	mkdir -p $(LIBRARY_PATH);

	# Making the java class library
	cp -f $(CLASSPATHJAR) $(JAVA_LIBRARY_PATH)/$(JAVA_LIBRARY_NAME); \
	( \
	    cd $(JAVA_LIBRARY_PATH); \
	    "$(JAVA_HOME)/bin/jar" uf $(JAVA_LIBRARY_NAME) -C $(CURDIR)/$(JAVA_CLASSPATH) .; \
	)

clean:
	@echo [$(APPLICATION_NAME)] Cleaning all...
	rm -rf $(TARGET)

.PHONY: all
.SILENT:
