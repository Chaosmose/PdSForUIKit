Pod::Spec.new do |s|
  s.name        = 'PDSCategoriesForUIKit'
  s.version     = '1.0'
  s.authors     = { 'Benoit Pereira da Silva' => 'benoit@pereira-da-silva.com' }
  s.homepage    = 'https://github.com/benoit-pereira-da-silva/PDSCategoriesForUIKit'
  s.summary     = 'A set of categories for UIKit)'
  s.source      = { :git => 'https://github.com/benoit-pereira-da-silva/PDSCategoriesForUIKit.git'}
  s.license     = { :type => "LGPL", :file => "LICENSE" }

  s.ios.deployment_target = '5.0'
  s.requires_arc = true
  s.source_files =  'Categories/*.{h,m}'
  s.public_header_files = 'Categories/*.h'
end