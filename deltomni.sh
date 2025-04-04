#!/bin/bash
map='AEIOU'
secret=''
code=''
key0=''
key1=''
tabb='ABCDEFGHIJKLMNOPRSTUVWXYZ'
op=':'
sep=','

uptabb(){
  local before=${tabb%%$1*}
  tabb="${tabb//$before}$before"
}

permutabb(){
  local target=$1
  local ikey=$(($2%${#key1}))
  local key=${key1:$ikey:1}
  tabb=${tabb//$key/§_§}
  tabb=${tabb//$target/$key}
  tabb=${tabb//§_§/$target}

}

cifra(){
  local point=-1
  local target=''
  local line=''
  local collumn=''
  
  rotkey=$((${#secret}%${#key0}))
  key0="${key0:$rotkey}${key0:0:$rotkey}"
  
  while (( point++ < ${#secret}-1 ));do
    target=${secret:$point:1}
    before=${tabb%%$target*}
    position=${#before}
    
    ikey=$((point%${#key0}))
    key=${key0:$ikey:1}
    before=${tabb%%$key*}
    
    ((position=(position+${#before})%${#tabb}))
    : $position
    line=$((${position}/${#map}))
    collumn=$((${position}%${#map}))    
      
    code+="${map:$line:1}${map:$collumn:1}$sep"
    uptabb $target
    permutabb $target $point
  done
  echo ${code%$sep}
}

decifra(){
  local point=-1
  par=0
  local line=''
  local collumn=''
  local target=''
  
  rotkey=$(((${#code}/2)%${#key0}))
  key0="${key0:$rotkey}${key0:0:$rotkey}"
  
  while (( point++ < (${#code}-1)/2 )); do
    
    line=${code:$((par)):1}
    line=${map%%$line*}
    line=${#line}
    
    collumn=${code:$par+1:1}
    collumn=${map%%$collumn*}
    collumn=${#collumn}
    
    position=$((line*${#map}+collumn))
    
    ikey=$((point%${#key0}))
    key=${key0:$ikey:1}
    before=${tabb%%$key*}
    
    ((position=(position-${#before})%${#tabb}))
    : $position
    target=${tabb:$position:1}
    secret+="$target"

    uptabb $target
    permutabb $target $point
    ((par++, par++))
  done
  echo ${secret}
}

while [[ $1 ]];do
  case ${1%%=*} in
  -d|--decifrar)
    shift
    code="${@^^}"
    nega="[^$map]"
    code=${code//$nega}
    op='decifra'
  ;;
  -k|--key0)
    shift
    key0=${1^^}
    key0=${key0//[^A-Z]}
  ;;
  -K|--key1)
    shift
    key1=${1^^}
    key1=${key1//[^A-Z]}
  ;;
  -M|--map)
    shift
    map=${1^^}
  ;;
  -t|tabble)
    shift
    tabb=${1^^}
  ;;
  -s|--separetor)
    shift
    sep=${1:-,}
  ;;
  -c|cifar)
    shift
    secret="${@^^}"
    nega="[^$tabb]"
    secret=${secret//$nega}
    op='cifra'
  ;;
  *);;
  esac
  shift
done
$op
