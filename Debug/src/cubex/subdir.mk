################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/cubex/CubexException.cpp \
../src/cubex/Face.cpp \
../src/cubex/FrameBuffer.cpp \
../src/cubex/GLObject.cpp \
../src/cubex/Mesh.cpp \
../src/cubex/MeshBuffer.cpp \
../src/cubex/ObjMeshLoader.cpp \
../src/cubex/Rectangle.cpp \
../src/cubex/ShaderProgram.cpp \
../src/cubex/Sprite.cpp \
../src/cubex/Texture.cpp \
../src/cubex/cubex.cpp 

OBJS += \
./src/cubex/CubexException.o \
./src/cubex/Face.o \
./src/cubex/FrameBuffer.o \
./src/cubex/GLObject.o \
./src/cubex/Mesh.o \
./src/cubex/MeshBuffer.o \
./src/cubex/ObjMeshLoader.o \
./src/cubex/Rectangle.o \
./src/cubex/ShaderProgram.o \
./src/cubex/Sprite.o \
./src/cubex/Texture.o \
./src/cubex/cubex.o 

CPP_DEPS += \
./src/cubex/CubexException.d \
./src/cubex/Face.d \
./src/cubex/FrameBuffer.d \
./src/cubex/GLObject.d \
./src/cubex/Mesh.d \
./src/cubex/MeshBuffer.d \
./src/cubex/ObjMeshLoader.d \
./src/cubex/Rectangle.d \
./src/cubex/ShaderProgram.d \
./src/cubex/Sprite.d \
./src/cubex/Texture.d \
./src/cubex/cubex.d 


# Each subdirectory must supply rules for building sources it contributes
src/cubex/%.o: ../src/cubex/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C++ Compiler'
	g++ -I"C:\Users\imizus\Projects\cubex\include" -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


