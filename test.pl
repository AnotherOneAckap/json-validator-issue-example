use strict;
use warnings;
use feature 'say';
use local::lib 'local';

use JSON::Validator;
use FindBin '$Bin';

{
	my $jv = JSON::Validator->new;
	$jv->schema("file://$Bin/openapi.yaml");

	say "\nUsing ", $jv->schema->get([info => 'title']);

	validate_response($jv, 'invalid value');
	validate_response($jv, 'valid value');
}

{
	my $jv = JSON::Validator->new;
	$jv->schema("file://$Bin/openapi1.yaml");

	say "\nUsing ", $jv->schema->get([info => 'title']);

	validate_response($jv, 'invalid value');
	validate_response($jv, 'valid value');
}

sub validate_response {
	my ($jv, $value) = @_;

	say "  Validating response: $value";

	my @errors = $jv->schema->validate_response(
		[ get => '/' => 200 ],
		{ body => { body => $value } }
	);

	for my $err ( @errors ) {
		say "  ERROR ", $err;
	}

	say "  OK, no errors" unless @errors;
	say '';
}
