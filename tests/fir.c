
#include <stdio.h>
#include <inttypes.h>  // For PRIu64, PRIi64
#include "rocc.h"
#include "encoding.h"

#define N 16  // Number of FIR filter taps
#define SIZE 4  // Number of sample inputs

int main(void) {
    int64_t hwFIRRes[SIZE];    
    int64_t sampled_signal[SIZE] = {100, 200, 300, 400};  // Test inputs
    int64_t coeff[N] = {23711, 106071, 196296, 255436, 255436, 196296, 106071, 23711,
                        23711, 106071, 196296, 255436, 255436, 196296, 106071, 23711};  // FIR coefficients

    printf("Hardware FIR Test\n");

    // Step 1: Load coefficients into FIR accelerator (mode 0)
    printf("Loading coefficients...\n");
    for (int i = 0; i < N; i++) {
        printf("Loading coefficient %d: %" PRIi64 "\n", i, coeff[i]); // Debugging line
        uint64_t dummy = 0;
        ROCC_INSTRUCTION_DS(0, dummy, coeff[i], 0);  // Send coefficients as rs1 values
    }

    // Step 2: Process sampled signal using hardware FIR (mode 2)
    printf("Running FIR filter on sampled signal...\n");
    for (int i = 0; i < SIZE; i++) {
        uint64_t result = 0;
        printf("Passing input %d: %" PRIi64 "\n", i, sampled_signal[i]); // Debugging line
        ROCC_INSTRUCTION_DS(0, result, sampled_signal[i], 2);  // Pass input to FIR accelerator and get output
        hwFIRRes[i] = result;  // Store the result in array
    }

    // Step 3: Print the hardware FIR results
    printf("Results from FIR accelerator:\n");
    for (int i = 0; i < SIZE; i++) {
        printf("Input: %" PRIi64 ", Output: %" PRIi64 "\n", sampled_signal[i], hwFIRRes[i]);
    }

    printf("Test completed.\n");
    return 0;
}
*/