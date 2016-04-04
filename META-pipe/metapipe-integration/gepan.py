import sys
import os
import logging
import drmaa
import subprocess

STATUS_RUNNING = "running"
STATUS_FAILED = "failed"
STATUS_SUCCEEDED = "succeeded"
STATUS_NOT_STARTED = "not_started"
STATUS_TERMINATED = "terminated"
STATUS_UNKNOWN = "unknown: (software bug)"

FILE_TERMINATED = "TERMINATED"


class JobManager:
    def __init__(self, gepan, job_id):
        self.logger = logging.getLogger(self.__class__.__name__)
        self.gepan = gepan
        self.job_id = job_id
        self.job_dir = os.path.join(gepan.work_dir, job_id)
        self.log_dir = os.path.join(self.job_dir, 'logs')
        self.result_dir = os.path.join(self.job_dir, 'results')
        self.shell_dir = os.path.join(self.job_dir, 'shells')
        self.submit_jobs_script = os.path.join(self.shell_dir, 'submit_jobs.sh')

    def status(self):
        if not self.job_started():
            return STATUS_NOT_STARTED
        if self.terminated():
            return STATUS_TERMINATED
        if self.job_running():
            return STATUS_RUNNING
        if self.job_failed():
            return STATUS_FAILED
        # If the job has been started, but its not running nor failed then it must have succeeded.
        return STATUS_SUCCEEDED

    def job_started(self):
        return self.job_dir_exists()

    def job_running(self):
        ids = self.task_ids()
        statuses = self.drmaa_task_status(ids)
        return self.is_drmaa_job_running(statuses)

    def job_failed(self):
        if self.job_submission_failed():
            return True
        if self.individual_job_failed():
            return True
        if self.copy_results_failed():
            return True
        return False

    def job_submission_failed(self):
        if self.task_ids().count('') > 0:
            self.logger.warn('''Job submission failed! Detected by one or more of the cluster manager task IDs being
             empty (see 'logs/*.jid.log'). It is likely that `qsub` has failed.''')
            return True
        return False

    def individual_job_failed(self):
        def match_pattern(pattern):
            with open(os.devnull, 'wb') as f:
                if subprocess.call(['grep', '-r', pattern, self.log_dir], stdout=f) == 0:
                    return True
        patterns = [
            'ERROR',
            '^mv: cannot stat',
            '^cp: cannot stat',
            '^Error:'
        ]
        job_failed = False
        for p in patterns:
            if match_pattern(p):
                self.logger.warn("Job failed! Failure detected by running 'grep' in the log directory with the " +
                                 "following pattern: '%s'" % p)
                job_failed = True

        return job_failed

    def copy_results_failed(self):
        # Verify existence of output file
        # Verify that output file size > 0B
        return False

    def job_dir_exists(self):
        return os.path.exists(self.job_dir)

    def task_ids(self):
        task_files = [f for f in os.listdir(self.log_dir) if f.endswith(".jid.log")]

        def get_job_id(filename):
            path = os.path.join(self.log_dir, filename)
            with open(path) as f:
                return f.read().rstrip('\n\r')
        return map(get_job_id, task_files)

    def drmaa_task_status(self, job_ids):
        session = drmaa.Session()
        session.initialize()
        try:
            statuses = [session.jobStatus(jid) for jid in job_ids]
            self.logger.debug("statuses: " + str(statuses))
        finally:
            session.exit()
        return statuses

    def is_drmaa_job_running(self, statuses):
        # When Torque no longer keeps track of a job the job is marked as 'failed',
        # i.e. jobs go from 'running' -> 'done' -> 'failed' regardless of whether it succeeds or not.
        # Therefore the 'failed' state tells us nothing more than that the job does not run (for any reason). Therefore
        # we only differentiate between these two states.
        # If the job is in queue or on hold we report it as 'running' as it's about to be run.
        failed_count = statuses.count(drmaa.JobState.FAILED)
        done_count = statuses.count(drmaa.JobState.DONE)
        if failed_count + done_count == len(statuses):
            return False
        else:
            return True

    def wait_for(self):
        ids = self.task_ids()
        session = drmaa.Session()
        session.initialize()
        try:
            self.logger.info("Waiting for the following jobs to complete: " + str(ids))
            for id in ids:
                session.wait(id, drmaa.Session.TIMEOUT_WAIT_FOREVER)
        finally:
            session.exit()
        status = self.status()
        self.logger.info("Job finished with the following status: " + status)
        return status

    def stop(self):
        self.touch(FILE_TERMINATED)
        ids = self.task_ids()
        not_terminated = []
        self.logger.info("Terminating jobs: " + str(ids))
        session = drmaa.Session()
        session.initialize()
        try:
            for jid in ids:
                try:
                    session.control(jid, drmaa.JobControlAction.TERMINATE)
                except drmaa.InvalidJobException:
                    not_terminated.append(jid)
                except Exception as e:
                    self.logger.warn("Unexpected exception when terminating job (%s):" % jid, e)
                    not_terminated.append(jid)
        finally:
            session.exit()
        if len(not_terminated) > 0:
            self.logger.debug("Did not terminate the following jobs as they did not exist (any more?): " + str(not_terminated))

    def start(self, args):
        status = self.status()
        if status != STATUS_NOT_STARTED:
            self.logger.info("Job already started. Not starting it again.")
            return status
        self.create_job_dir(args)
        if self.submit_jobs() != 0:
            return STATUS_FAILED
        return STATUS_RUNNING

    def result(self):
        files = os.listdir(self.result_dir)
        return map(lambda fn: os.path.join(self.result_dir, fn), files)

    def terminated(self):
        if self.file_exists(FILE_TERMINATED):
            return True
        else:
            return False

    def touch(self, filename):
        f = open(os.path.join(self.job_dir, filename), 'w')
        f.write('')
        f.close()

    def file_exists(self, filename):
        return os.path.exists(os.path.join(self.job_dir, filename))

    def create_job_dir(self, args):
        base_cmd = [self.gepan.gepan_start_script, '-g', self.job_id, '-w', self.gepan.work_dir]
        cmd = base_cmd + args
        self.logger.debug("Running startGepan: " + str(cmd))
        with open(os.devnull, 'wb') as f:
            subprocess.call(cmd, stdout=f)

    def submit_jobs(self):
        cmd = ['sh', self.submit_jobs_script]
        self.logger.debug("Submitting jobs: " + str(cmd))
        with open(os.devnull, 'wb') as f:
            p = subprocess.Popen(cmd, stdout=f, stderr=subprocess.PIPE)
            err = p.stderr.read().strip('\r\n')
            ret = p.wait()
            if ret != 0:
                self.logger.warn("Submit jobs failed: %s" % err)
        return ret


class Gepan:
    def __init__(self, gepan_work_dir, gepan_home):
        self.work_dir = gepan_work_dir
        self.gepan_start_script = os.path.join(gepan_home, 'start_gepan.sh')

    def status(self, job_id):
        manager = JobManager(self, job_id)
        return manager.status()

    def start(self, job_id, args):
        manager = JobManager(self, job_id)
        return manager.start(args)

    def stop(self, job_id):
        manager = JobManager(self, job_id)
        manager.stop()
        return STATUS_TERMINATED

    def wait_for(self, job_id):
        manager = JobManager(self, job_id)
        return manager.wait_for()

    def result(self, job_id):
        manager = JobManager(self, job_id)
        return manager.result()

    def directory(self, job_id):
        manager = JobManager(self, job_id)
        return manager.job_dir

def main():
    logging.basicConfig(level=0)
    work_dir = os.environ['GEPAN_WORK_DIR']
    gepan_home = os.environ['GEPAN_HOME']

    cmd = sys.argv[1]
    job_id = sys.argv[2]
    args = sys.argv[3:]

    gepan = Gepan(gepan_work_dir=work_dir, gepan_home=gepan_home)

    if cmd == 'start':
        gepan.start(job_id=job_id, args=args + ['-R', '-P'])
    elif cmd == 'status':
        print gepan.status(job_id=job_id)
    elif cmd == 'stop':
        gepan.stop(job_id=job_id)
    elif cmd == 'wait_for':
        print gepan.wait_for(job_id=job_id)
    elif cmd == 'result':
        files = gepan.result(job_id=job_id)
        for file_name in files:
            print file_name
    elif cmd == 'directory' or cmd == 'dir':
        print gepan.directory(job_id)
    else:
        print "Invalid argument"
        sys.exit(1)

if __name__ == '__main__':
    main()