#!/usr/bin/env python
#
# plot_gpu_mem.py <ssaver_tests_logfile>
#
# This script will take a plain logfile from the Screen Saver tests,
# and generate a plot graph of the GPU free memory samples throughout the tests.
#
# Y axis shows the amount of free GPU memory, X axis shows the number of samples.
#

import sys
import matplotlib.pyplot as plt


if __name__ == '__main__':

    leak_numbers=[]
    output_graph_file='plot_gpu_mem.png'

    if len(sys.argv) < 2:
        print 'please provide a Screen Saver tests log file'
        sys.exit(1)
    else:
        logfile=sys.argv[1]

    leak_lines=open(logfile, 'r').readlines()

    for l in leak_lines:
        if l.startswith('reloc'):
            a_leak=l.split('=')[1].strip('M\n')
            leak_numbers.append(a_leak)

    print leak_numbers

    x = range(0, len(leak_numbers))
    plt.plot(x, leak_numbers)

    plt.title('Screen Saver testing with GPU free memory sampling')
    plt.ylabel('GPU free mem in MB')
    plt.xlabel('Number of memory samples')

    plt.savefig(output_graph_file)
