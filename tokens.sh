#!/usr/bin/env bash

declare -A tokens=( # password policies
  [V]="AEIOUY"
  [C]="BCDFGHJKLMNPQRSTVWXZ"
  [v]="aeiouy"
  [c]="bcdfghjklmnpqrstvwxz"
  [A]="AEIOUYBCDFGHJKLMNPQRSTVWXZ"
  [a]="AEIOUYaeiouyBCDFGHJKLMNPQRSTVWXZbcdfghjklmnpqrstvwxz"
  [n]="0123456789"
  [s]="@&?,=[]_:-+*\$#!\'^~;()/."
  [x]="AEIOUYaeiouyBCDFGHJKLMNPQRSTVWXZbcdfghjklmnpqrstvwxz0123456789@&?,=[]_:-+*\$#!\'^~;()/."
)

declare -A alias=( # reference to password policies
  [l]="vc" # lowercase
  [u]="VC" # uppercase
)
