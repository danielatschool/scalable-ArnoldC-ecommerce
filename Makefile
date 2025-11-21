# Makefile for ArnoldC E-commerce Platform

# Compiler
ARNOLDC = arnoldc

# Source files
SRC = src/main.arnoldc src/product.arnoldc src/cart.arnoldc src/user.arnoldc
TARGET = ecommerce

all: $(TARGET)

$(TARGET): $(SRC)
	$(ARNOLDC) -o $@ $^

clean:
	rm -f $(TARGET)

.PHONY: all clean
