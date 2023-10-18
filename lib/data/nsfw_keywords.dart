bool checkForNsfwKeywords(String text) {
  // Список NSFW ключевых слов
  String nsfwTextList1 =
      "cock, deepthroat, dick, cumshot, wet, fuck, sperm, jerk off, naked, ass, tits, fingering, masturbate, bitch, blowjob, prostitute, shit, bullshit, dumbass, dickhead, pussy, piss, asshole, boobs, butt, booty, dildo, erection, foreskin, gag, handjob, licking, nude, penis, porn, vibrator, viagra, virgin, vagina, vulva, wet dream, threesome, orgy, bdsm, hickey, condom, sexting, squirt, testicles, anal, bareback, bukkake, creampie, stripper, strap-on, missionary, make out, clitoris, cock ring, sugar daddy, cowgirl, reach-around, doggy style, fleshlight, contraceptive, makeup sex, lingerie, butt plug, moan, milf, wank, oral, sucking, kiss, dirty talk, straddle, blindfold, bondage, orgasm, french kiss, scissoring, deeper, don't stop, slut, cumming, dirty, ode, men's milk, pound, jerk, prick, cunt, bastard, faggot, anal, anus";
  List<String> nsfwListSplit1 = nsfwTextList1.split(', ');
  String nsfwTextList2 = """2g1c
2 girls 1 cup
acrotomophilia
alabama hot pocket
alaskan pipeline
anal
anilingus
anus
apeshit
arsehole
ass
asshole
assmunch
auto erotic
autoerotic
babeland
baby batter
baby juice
ball gag
ball gravy
ball kicking
ball licking
ball sack
ball sucking
bangbros
bangbus
bareback
barely legal
barenaked
bastard
bastardo
bastinado
bbw
bdsm
beaner
beaners
beaver cleaver
beaver lips
beastiality
bestiality
big black
big breasts
big knockers
big tits
bimbos
birdlock
bitch
bitches
black cock
blonde action
blonde on blonde action
blowjob
blow job
blow your load
blue waffle
blumpkin
bollocks
bondage
boner
boob
boobs
booty call
brown showers
brunette action
bukkake
bulldyke
bullet vibe
bullshit
bung hole
bunghole
busty
butt
buttcheeks
butthole
camel toe
camgirl
camslut
camwhore
carpet muncher
carpetmuncher
chocolate rosebuds
cialis
circlejerk
cleveland steamer
clit
clitoris
clover clamps
clusterfuck
cock
cocks
coprolagnia
coprophilia
cornhole
coon
coons
creampie
cum
cumming
cumshot
cumshots
cunnilingus
cunt
darkie
date rape
daterape
deep throat
deepthroat
dendrophilia
dick
dildo
dingleberry
dingleberries
dirty pillows
dirty sanchez
doggie style
doggiestyle
doggy style
doggystyle
dog style
dolcett
domination
dominatrix
dommes
donkey punch
double dong
double penetration
dp action
dry hump
dvda
eat my ass
ecchi
ejaculation
erotic
erotism
escort
eunuch
fag
faggot
fecal
felch
fellatio
feltch
female squirting
femdom
figging
fingerbang
fingering
fisting
foot fetish
footjob
frotting
fuck
fuck buttons
fuckin
fucking
fucktards
fudge packer
fudgepacker
futanari
gangbang
gang bang
gay sex
genitals
giant cock
girl on
girl on top
girls gone wild
goatcx
goatse
god damn
gokkun
golden shower
goodpoop
goo girl
goregasm
grope
group sex
g-spot
guro
hand job
handjob
hard core
hardcore
hentai
homoerotic
honkey
hooker
horny
hot carl
hot chick
how to kill
how to murder
huge fat
humping
incest
intercourse
jack off
jail bait
jailbait
jelly donut
jerk off
jigaboo
jiggaboo
jiggerboo
jizz
juggs
kike
kinbaku
kinkster
kinky
knobbing
leather restraint
leather straight jacket
lemon party
livesex
lolita
lovemaking
make me come
male squirting
masturbate
masturbating
masturbation
menage a trois
milf
missionary position
mong
motherfucker
mound of venus
mr hands
muff diver
muffdiving
nambla
nawashi
negro
neonazi
nigga
nigger
nig nog
nimphomania
nipple
nipples
nsfw
nsfw images
nude
nudity
nutten
nympho
nymphomania
octopussy
omorashi
one cup two girls
one guy one jar
orgasm
orgy
paedophile
paki
panties
panty
pedobear
pedophile
pegging
penis
phone sex
piece of shit
pikey
pissing
piss pig
pisspig
playboy
pleasure chest
pole smoker
ponyplay
poof
poon
poontang
punany
poop chute
poopchute
porn
porno
pornography
prince albert piercing
pthc
pubes
pussy
queaf
queef
quim
raghead
raging boner
rape
raping
rapist
rectum
reverse cowgirl
rimjob
rimming
rosy palm
rosy palm and her 5 sisters
rusty trombone
sadism
santorum
scat
schlong
scissoring
semen
sex
sexcam
sexo
sexy
sexual
sexually
sexuality
shaved beaver
shaved pussy
shemale
shibari
shit
shitblimp
shitty
shota
shrimping
skeet
slanteye
slut
s&m
smut
snatch
snowballing
sodomize
sodomy
spastic
spic
splooge
splooge moose
spooge
spread legs
spunk
strap on
strapon
strappado
strip club
style doggy
suck
sucks
suicide girls
sultry women
swastika
swinger
tainted love
taste my
tea bagging
threesome
throating
thumbzilla
tied up
tight white
tit
tits
titties
titty
tongue in a
topless
tosser
towelhead
tranny
tribadism
tub girl
tubgirl
tushy
twat
twink
twinkie
two girls one cup
undressing
upskirt
urethra play
urophilia
vagina
venus mound
viagra
vibrator
violet wand
vorarephilia
voyeur
voyeurweb
voyuer
vulva
wank
wetback
wet dream
white power
whore
worldsex
wrapping men
wrinkled starfish
xx
xxx
yaoi
yellow showers
yiffy
zoophilia
bychara
byk
chernozhopyi
dolboy'eb
ebalnik
ebalo
ebalom sch'elkat
gol
mudack
opizdenet
osto'eblo
ostokhuitel'no
ot'ebis
otmudohat
otpizdit
otsosi
padlo
pedik
perdet
petuh
pidar gnoinyj
pizda
pizdato
pizdatyi
piz'det
pizdetc
pizdoi nakryt'sja
pizd'uk
piz`dyulina
podi ku'evo
poeben
po'imat' na konchik
po'iti posrat
po khuy
poluchit pizdy
pososi moyu konfetku
prissat
proebat
promudobl'adsksya pizdopro'ebina
propezdoloch
prosrat
raspeezdeyi
raspizdatyi
raz'yebuy
raz'yoba
s'ebat'sya
shalava
styervo
sukin syn
svodit posrat
svoloch
trakhat'sya
trimandoblydskiy pizdoproyob
ubl'yudok
uboy
u'ebitsche
vafl'a
vafli lovit
v pizdu
vyperdysh
vzdrochennyi
yeb vas
za'ebat
zaebis
zalupa
zalupat
zasranetc
zassat
zlo'ebuchy
бздёнок
блядки
блядовать
блядство
блядь
бугор
во пизду
встать раком
выёбываться
гандон
говно
говнюк
голый
дать пизды
дерьмо
дрочить
другой дразнится
ёбарь
ебать
ебать-копать
ебло
ебнуть
ёб твою мать
жопа
жополиз
играть на кожаной флейте
измудохать
каждый дрочит как он хочет
какая разница
как два пальца обоссать
курите мою трубку
лысого в кулаке гонять
малофья
манда
мандавошка
мент
муда
мудило
мудозвон
наебать
наебениться
наебнуться
на фиг
на хуй
на хую вертеть
на хуя
нахуячиться
невебенный
не ебет
ни за хуй собачу
ни хуя
обнаженный
обоссаться можно
один ебётся
опесдол
офигеть
охуеть
охуительно
половое сношение
секс
сиськи
спиздить
срать
ссать
траxать
ты мне ваньку не валяй
фига
хапать
хер с ней
хер с ним
хохол
хрен
хуёво
хуёвый
хуем груши околачивать
хуеплет
хуило
хуиней страдать
хуиня
хуй
хуйнуть
хуй пинать""";
  List<String> nsfwListSplit2 = nsfwTextList2.split('\n');
  List<String> nsfwKeywords = [
    'sex',
    'porn',
    'gore',
    'nude',
    'naked',
    'nsfw',
    'xxx',
    '18+',
    '+18',
    'nsfl',
    'nsfp',
    'nsfwl',
    'nsfwp',
    'suicide',
    'lesbian',
    'gay',
    'hentai',
    'xnxx',
    'jav',
    'bokep',
    'dick',
    'fuck',
    'darknet',
  ]
    ..addAll(nsfwListSplit1)
    ..addAll(nsfwListSplit2); // Здесь вы можете добавить любые другие NSFW ключевые слова
  // Преобразуем текст в нижний регистр для регистронезависимого сравнения
  String lowerCaseText = text.toLowerCase();

  // Проверяем, содержит ли текст NSFW ключевые слова
  for (String keyword in nsfwKeywords) {
    if (lowerCaseText.contains(keyword)) {
      return true;
    }
  }
  return false;
}
