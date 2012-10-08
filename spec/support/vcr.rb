VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock # or :fakeweb
end