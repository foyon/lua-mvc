<?php
/**
 *demo http ask, postdata=json
 *
 * usage : cli=> php ngx_lua_test.php 2
 */
$i = $argv[1];
$pro = $argv[2];
if(!$pro)
    $pro = 'json';

$url = "http://127.0.0.1:80/demo/index.lua?uid=122222&gameid=1000001&platform=android";


$json_array[2] = array(
    'class'=>'moregame',
    'method'=>'test',
    'msgid'=>121212121,
    'params'=>array());


$param =json_encode($json_array[$i]);

$ret = http_post($url, $param);

function http_post($url, $data)                                                                                               
{/*{{{*/                                                                                                                      
    $ch = curl_init();                                                                                                        
    curl_setopt($ch, CURLOPT_URL, $url);                                                                                      
    curl_setopt($ch, CURLOPT_POST, true);                                                                                     
    var_dump($data);
    //curl_setopt($ch, CURLOPT_HTTPHEADER,array('Accept:application/json',
    //'Content-Type:application/json;charset=utf-8'));
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);                                                                              
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);                                                                           
    curl_setopt($ch, CURLOPT_TIMEOUT, 120);                                                                                    
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 120);                                                                             
    curl_setopt($ch, CURLOPT_NOSIGNAL, 1 );                                                                                   

    echo "begin\n";
    $res = curl_exec($ch);
    echo $res;
    echo "end\n";
    $errno = curl_errno($ch);                                                                                                 
    $errmsg = curl_error($ch);                                                                                                
    curl_close($ch);                                                                                                          
    return $res;                                                                                                              
}/*}}}*/   
?>
