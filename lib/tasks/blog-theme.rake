namespace :blog_theme do
  desc 'Update the wordpress blog theme'
  task :update => :environment do
    puts "Updating wordpress theme"
    require 'action_controller/integration'
    app = ActionController::Integration::Session.new;
    # Change this to the production url for your blog_theme
    blog_theme_url = "http://localhost:3000/blog_theme"
    app.get(blog_theme_url)
    index_content = app.html_document.root.to_s
    # Change theme_home to the correct path for your
    # environment, leave the final directory as rails-generated
    theme_home = '../globalquiver_blog/wp-content/themes/rails-generated'
    mkdir theme_home unless File.exists? theme_home
    index_path = "#{theme_home}/index.php"
    puts "Writing index.php to '#{index_path}'"
    File.open(index_path, 'w') {|f| f.write(index_content) }
    puts "chmod index.php"
    File.chmod(0755, index_path)
    puts "Copying style.css to '#{theme_home}'"
    cp 'public/stylesheets/wordpress/style.css',
      "#{theme_home}/style.css", :verbose => true
    puts "Wordpress theme updated"
  end
end