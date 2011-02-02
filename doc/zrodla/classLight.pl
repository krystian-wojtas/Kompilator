sub invoke
{
	my ( $self, $prWNr ) = @_;
	$self->drukujKod( "invoke $prWNr" );
	return $self;
}

sub ldc
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("ldc $pozycja");
	return $self;
}

sub getfield
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("getfield $pozycja");
	return $self;
}

sub astore
{
	my ( $self, $pozycja ) = @_;
	$self->drukujKod("astore $pozycja");
	return $self;
}

sub iadd
{
	my $self  = shift;
	$self->drukujKod('iadd');
	return $self;
}

sub b2i
{
	my $self  = shift;
	$self->drukujKod('b2i');
	return $self;
}
