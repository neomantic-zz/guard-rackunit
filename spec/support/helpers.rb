def test_path
  support_file_path("/tests")
end

def with_failed_stderr
  File.open(support_file_path("/samples/failed_tests")) do |io|
    yield io
  end
end

def with_successful_stdout
  File.open(support_file_path("/samples/success")) do |io|
    yield io
  end
end

def with_successful_stdout_and_stderr
  with_successful_stdout do |out_io|
    yield out_io, StringIO.new(''), stub_success_thread
  end
end

def with_failure_stdout_and_stderr
  with_failed_stderr do |err_io|
    yield StringIO.new(''), err_io, stub_failure_thread
  end
end

def support_file_path(name)
  File.expand_path(File.dirname(__FILE__) + name)
end

def stub_successful_process
  double(Process::Status, :success? => true)
end

def stub_failed_process
  double(Process::Status, :success? => false)
end

def stub_failure_thread
  double('wait_thr', pid: 1, value: stub_failed_process)
end

def stub_success_thread
  double('wait_thr', pid: 1, value: stub_successful_process)
end

def stub_successful_run
  with_successful_stdout_and_stderr do |out, err, thread|
    Open3.stub(:popen3).and_yield(StringIO.new(''), out, err, thread)
    if block_given?
      yield out, err, thread.value
    end
  end
end

def stub_failed_run
  with_failure_stdout_and_stderr do |out, err, thread|
    Open3.stub(:popen3).and_yield(StringIO.new(''), out, err, thread)
    if block_given?
      yield out, err, thread.value
    end
  end
end

def capture_stdout
  # borrowed from
  # https://github.com/cldwalker/hirb/blob/master/test/test_helper.rb
  # MIT license
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end
