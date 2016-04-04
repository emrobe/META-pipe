#!/usr/bin/env python2.7
import os
import sys
import time
import logging


class MockGepan:
    def __init__(self, gepan_work_dir, job_id):
        logging.basicConfig(level=0, stream=sys.stderr)
        self.logger = logging.getLogger(self.__class__.__name__)
        self.gepan_work_dir = gepan_work_dir
        self.job_id = job_id
        self.job_dir = os.path.join(self.gepan_work_dir, self.job_id)
        self.results_dir = os.path.join(self.job_dir, 'results')
        self.output_file = os.path.join(self.results_dir, 'output.txt')

        self.logger.debug('Using work directory: %s' % self.gepan_work_dir)
        self.logger.debug('Using job directory: %s' % self.job_dir)
        self.logger.debug('Using results directory: %s' % self.results_dir)

    def start(self, args):
        self.logger.info('Pretending to start Gepan')
        self.create_job_dir()
        # Fake result -- contains useful debug info
        fake_result = '''
        job_id: %s
        args: %s
        job_dir: %s
        ''' % (self.job_id, args, self.job_dir)
        with open(self.output_file, 'w') as f:
            f.write(fake_result)

    def stop(self):
        self.logger.info('Pretending to stop Gepan')
        pass

    def wait_for(self):
        self.logger.info('Pretending to wait for Gepan')
        time.sleep(1)
        print 'succeeded'

    def get_results(self):
        self.logger.info('Getting results')
        for result_file in os.listdir(self.results_dir):
            result_path = os.path.join(self.results_dir, result_file)
            self.logger.debug('Returning result: %s' % result_path)
            print result_path

    def create_gepan_work_dir(self):
        if not os.path.exists(self.gepan_work_dir):
            self.logger.debug('Creating work directory')
            os.mkdir(self.gepan_work_dir, 0755)

    def create_job_dir(self):
        if not os.path.exists(self.job_dir):
            self.logger.debug('Creating job directory')
            os.mkdir(self.job_dir, 0755)
        if not os.path.exists(self.results_dir):
            self.logger.debug('Creating results directory')
            os.mkdir(self.results_dir, 0755)


def main():
    work_dir = os.environ['GEPAN_WORK_DIR']

    op = sys.argv[1]
    job_id = sys.argv[2]
    args = sys.argv[3:]

    gepan = MockGepan(work_dir, job_id)
    gepan.create_gepan_work_dir()

    if op == 'start':
        gepan.start(args)
    elif op == 'stop':
        gepan.stop()
    elif op == 'wait_for':
        gepan.wait_for()
    elif op == 'result':
        gepan.get_results()


if __name__ == '__main__':
    main()