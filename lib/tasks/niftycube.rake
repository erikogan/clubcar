NIFTY_STAGING_DIR = "/tmp/nifty_cube.#{$$}"
NIFTY_ZIP = File.expand_path(File.dirname(__FILE__) + '/../../vendor/NiftyCube.zip')
NIFTY_PATCH = File.expand_path(File.dirname(__FILE__) + '/../../vendor/NiftyCube.patch')
NIFTY_JS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../public/javascripts/NiftyCube')
NIFTY_CSS_DIR = File.expand_path(File.dirname(__FILE__) + '/../../public/stylesheets/NiftyCube')

def assure_dir(dir)
  unless (File.exists?(dir) && File.directory?(dir))
    Dir.mkdir(dir)
  end
end

namespace :niftycube do
  desc "Unpack the Zip file"
  task (:unzip => :clean_staging) do
    assure_dir(NIFTY_STAGING_DIR)
    sh "unzip -d #{NIFTY_STAGING_DIR} #{NIFTY_ZIP} "
  end
  
  desc "Patch the zipfile with local changes"
  task (:patch => :unzip) do
    if (File.exist?(NIFTY_PATCH)) 
      Dir.chdir(NIFTY_STAGING_DIR) {sh "patch -p1 < #{NIFTY_PATCH}"}
    end
  end
  
  desc "Clean up the build area"
  task (:clean_staging) do
    sh "rm -rf #{NIFTY_STAGING_DIR}"
  end
  
  desc "Install files"
  task(:install => :patch) do
    assure_dir(NIFTY_JS_DIR)
    assure_dir(NIFTY_CSS_DIR)
    #Dir.chdir(NIFTY_STAGING_DIR) do
      sh "install -m 0644 #{FileList[File.join(NIFTY_STAGING_DIR, 'NiftyCube', '*.js')]} #{NIFTY_JS_DIR}"
      sh "install -m 0644 #{FileList[File.join(NIFTY_STAGING_DIR, 'NiftyCube', '*.css')]} #{NIFTY_CSS_DIR}"
    #end
    Rake::Task['niftycube:clean_staging'].execute
  end
  
end