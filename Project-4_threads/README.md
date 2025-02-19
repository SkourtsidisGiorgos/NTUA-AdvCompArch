# Advanced Computer Architecture Topics - Assignment 4
## National Technical University of Athens
### School of Electrical and Computer Engineering
### Computer Systems Laboratory
www.cslab.ece.ntua.gr

8th Semester, Academic Year 2019-2020
Final Submission Date: 21/06/2020

## Part A

### 1. Introduction
The goal of this assignment is to become familiar with synchronization mechanisms and cache coherence protocols in modern multicore architectures. For this purpose, you are provided with multithreaded code with which you will implement various synchronization mechanisms, which you will then evaluate on a multicore simulated system using Sniper.

### 2. Implementation of Synchronization Mechanisms
You are required to implement the Test-and-Set (TAS) and Test-and-Test-and-Set (TTAS) locking mechanisms, as taught in the corresponding course slides.

Specifically, in the locks_scalability.c file, ready-made C code is provided that uses the Pthreads (Posix Threads) library for creating and managing software threads. The code creates a number of threads, each of which executes a critical section for a specific number of iterations. For all threads, entry into the critical section is controlled by a shared lock variable. Before entering the region, each thread executes the appropriate routine for acquiring the lock (lock acquire) to enter it exclusively. Inside the critical section, each thread performs a dummy cpu-intensive calculation. Upon exiting, it executes the appropriate routine for releasing the lock (lock release). By providing the appropriate flags during compilation, you can produce code that uses calls to TAS, TTAS, or Pthread mutex (MUTEX) locks. The last of these mechanisms is already implemented in the Pthreads library. You are required to implement the lock acquisition and release routines for the TAS and TTAS mechanisms.

#### 2.1 Implementation of TAS and TTAS Locks
More specifically, the routines you need to implement are spin_lock_tas_cas, spin_lock_tas_ts, spin_lock_ttas_cas, and spin_lock_ttas_cas. Their definitions are given, incomplete, in the lock.h file, and you will need to implement their main body. In the same file, the definition of the lock variable type (spinlock_t), the definition of constants that indicate whether the critical section is locked or free (LOCKED, UNLOCKED), and the definition of the lock variable initialization function which is called before thread creation are provided.

The implementation of the requested routines will be done using gcc's atomic intrinsics, specifically these 2 functions:
1. `int __sync_lock_test_and_set(int *ptr, int newval);`
2. `int __sync_val_compare_and_swap(int *ptr, int oldval, int newval);`

The first function implements an atomic exchange operation, namely:
```
atomically {
    write newval to *ptr and return the old value of *ptr
}
```

The second function implements an atomic compare-and-swap operation, namely:
```
atomically {
    if current value of *ptr is oldval, then write newval to *ptr.
    in any case return the old value of *ptr
}
```

#### 2.2 Program Description
The locks_scalability.c program accepts the following command line arguments:
- nthreads: the number of threads to be created
- iterations: the number of iterations the critical section will be executed by each thread
- grain_size: determines the volume of dummy, cpu-intensive calculations, and consequently the size of the critical section

In the program code, there are appropriate compile-time directives that define the inclusion or not during compilation time of a code segment. In this way, we can incorporate different versions of the program in a single file. The directives used, and their meaning, are as follows:
- SNIPER | REAL: activate the appropriate code segments for program execution in Sniper or on a real system, respectively
- TAS_CAS | TAS_TS | TTAS_CAS | TTAS_TS | MUTEX: activate calls to TAS, TTAS and Pthread Mutex synchronization mechanisms, respectively
- DEBUG: enables printing of debugging messages

[... continued in next sections ...]

### 3. Performance Evaluation
In this part, you are required to evaluate the performance of your implementations, both in terms of their scalability and thread topology.

[Full translated document continues with detailed sections about performance evaluation, experimental setup, and the Part B section about the Tomasulo algorithm implementation...]

*Note: All data structures, variable names, and code segments should be kept as in the original document for consistency.*
