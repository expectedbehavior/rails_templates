generate(:scaffold, "User", "email:string", "crypted_password:string", "password_salt:string", "persistence_token:string") 

run "rm app/views/users/*.erb"

file "app/views/users/index.haml", <<-END
%h2 User List
%ul
- @users.each do |u|
  %li= u.email
END
 
file "app/views/users/edit.haml", <<-END
%h2 Edit Profile
= render :partial => 'form'
END
 
file "app/views/users/new.haml", <<-END
%h2 New Profile
= render :partial => 'form'
END
 
file "app/views/users/_form.haml", <<-END
- form_for @user do |f|
  = f.error_messages
  %p
    = f.label :email
    %br
    = f.text_field :email
  %p
    = f.label :password
    %br
    = f.password_field :password
  %p
    = f.label :password_confirmation
    %br
    = f.password_field :password_confirmation
  %p
    = f.submit "Submit"
END

git :add => '.'
git :commit => "-m 'users'"
