
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Index and search your photos",
  "AUTHOR" => "Brian Phillips <bphillips\@cpan.org>",
  "BUILD_REQUIRES" => {
    "App::Cmd::Tester" => 0,
    "File::Find" => 0,
    "File::Temp" => 0,
    "Test::More" => 0,
    "Test::Number::Delta" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Imdex",
  "EXE_FILES" => [
    "bin/imdex"
  ],
  "LICENSE" => "perl",
  "NAME" => "Imdex",
  "PREREQ_PM" => {
    "App::Cmd::Setup" => "0.314",
    "Carp" => 0,
    "Cwd" => 0,
    "DBIx::Class::Candy" => 0,
    "DBIx::Class::ResultSet" => 0,
    "DBIx::Class::Schema" => 0,
    "DateTime" => 0,
    "DateTime::Format::Natural" => 0,
    "File::HomeDir" => 0,
    "Graphics::ColorObject" => "0.5.0",
    "Image::ExifTool" => "8.75",
    "Image::Magick" => 0,
    "Math::Complex" => 0,
    "SQL::Translator" => "0.11010",
    "Scalar::Util" => 0,
    "Sub::Exporter" => 0,
    "base" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "0.001",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



