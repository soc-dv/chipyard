#include <stdio.h>
#include <inttypes.h>  // Required for printing uint64_t
#include "rocc.h"      // Required for RoCC instructions

#define SIZE 5  // Small test size for quick validation

// Software GCD function
uint64_t gcd(uint64_t a, uint64_t b) {
    while (b != 0) {
        uint64_t temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

// Software LCM function
uint64_t lcm(uint64_t a, uint64_t b) {
    return (a / gcd(a, b)) * b;
}

int main() {
    uint64_t num1[SIZE] = {12, 15, 18, 20, 25};
    uint64_t num2[SIZE] = {18, 25, 30, 35, 40};

    uint64_t swLcmRes[SIZE];  // Software LCM results
    uint64_t hwLcmRes[SIZE];  // Hardware LCM results

    // Software computation of LCM
    for (int i = 0; i < SIZE; i++) {
        swLcmRes[i] = lcm(num1[i], num2[i]);
    }

    // Hardware computation using RoCC (LCM RoCC Accelerator)
    for (int i = 0; i < SIZE; i++) {
        asm volatile ("fence"); // Ensure memory consistency
        ROCC_INSTRUCTION_DSS(0, hwLcmRes[i], num1[i], num2[i], 0);
        asm volatile ("fence" ::: "memory");
    }

    // Print the LCM values for both software and hardware computations
    printf("LCM Results:\n");
    printf("Num1\tNum2\tSoftware LCM\tHardware LCM\n");
    for (int i = 0; i < SIZE; i++) {
        printf("%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\t%" PRIu64 "\n",
               num1[i], num2[i], swLcmRes[i], hwLcmRes[i]);
    }

    // Compare software and hardware results
    for (int i = 0; i < SIZE; i++) {
        if (swLcmRes[i] != hwLcmRes[i]) {
            printf("Test failed! %" PRIu64 " and %" PRIu64 " -> SW LCM: %" PRIu64 ", HW LCM: %" PRIu64 "\n",
                   num1[i], num2[i], swLcmRes[i], hwLcmRes[i]);
            return 1;
        }
    }

    printf("All tests passed! LCM RoCC Accelerator is working correctly.\n");
    return 0;
}
