#################################################################################
#	Функция getXMLAPIResponse будет использоваться во всех скриптах		#
#	в которых будет необходимость обращаться к XML API cPanel		#
#	Автор: Алексей Ваганов							#
#	Компания: Ксайберри							#
#	Сайт: http://xyberry.com						#
#	Email: aleksey@xyberry.com						#							
#################################################################################
package      cPanel::3rdparty::nginx;
require      Exporter;

our @ISA       = qw(Exporter);
our @EXPORT    = qw(getcPanelXMLAPIResponse);
$VERSION = "0.01"
use strict;
use warnings;
use LWP::UserAgent;

sub getAuthHash 
{
# Функция возвращает Hash для доступа к API cPanel
# Hash предварительно должен быть сгенерирован в WHM

	open HASHFILE, "</root/.accesshash" || die "Невозможно получить accesshash\n";
	my $hash = "";
	while (<HASHFILE>)
	{
		$hash .= $_;
	}
	close HASHFILE;
	$hash =~ s/\n//g;
	my $auth = "WHM root:" . $hash;
	return $auth;
}

sub getcPanelXMLAPIResponse
{
# Первым аргументом функция принимает имя функции API
# Во втором аргументе функции должен быть передан хэш аргументов

	my ($function, %args) = @_;
        my $url = "https://127.0.0.1:2087/xml-api/$function";
	my $args = "";
	if (%args)
	{
		foreach my $name (keys %args)
		{
			$args .= "$name=$args{$name}&";
		}
		$url .= "?$args";
	}
	my $ua = LWP::UserAgent->new;
	my $request = HTTP::Request->new( GET => $url );
	$request->header( Authorization => getAuthHash());
	my $response = $ua->request($request);
	return $response->content;
}

1;
