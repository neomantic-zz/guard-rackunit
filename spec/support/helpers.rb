def test_path
  support_file_path("/tests")
end

def with_failed_stderr(sample_path = '/samples/failed_tests')
  File.open(support_file_path(sample_path)) do |io|
    yield io
  end
end

def with_successful_stdout
  File.open(support_file_path("/samples/success")) do |io|
    yield io
  end
end

def support_file_path(name)
  File.expand_path(File.dirname(__FILE__) + name)
end

def stub_successful_run(paths = [])
  stub_paths(paths)
  with_successful_stdout do |stdout|
    thread = stub_success_process
    stderr = StringIO.new('')
    stub_run(stdout, stderr, thread)
    if block_given?
      yield stdout, stderr, thread.value
    end
  end
end

def stub_paths(paths)
  paths.collect do |path|
    allow(File).to receive(:exists?).at_least(:once).with(path).and_return true
  end
end

def stub_failed_run(paths = [])
  stub_paths(paths)
  with_failed_stderr do |stderr|
    stub_failed_run_err(stderr) do | stdout, stderr, thread|
      if block_given?
        yield stdout, stderr, thread
      end
    end
  end
end

def stub_failed_process
  process = double(Process::Status, :success? => false)
  double('wait_thr', pid: 1, value: process)
end

def stub_success_process
  process = double(Process::Status, :success? => true)
  double('wait_thr', pid: 1, value: process)
end

def stub_failed_run_err(stderr, path = '')
  stub_paths([path]) unless path.empty?
  stdout = StringIO.new('')
  thread = stub_failed_process
  stub_run(stdout, stderr, thread)
  if block_given?
    yield stdout, stderr, thread.value
  end
end

def stub_run(stdout, stderr, thread = stub_success_process)
  Open3.stub(:popen3).and_yield(StringIO.new(''), stdout, stderr, thread)
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
