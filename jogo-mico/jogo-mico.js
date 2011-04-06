//set main namespace
goog.provide('jogo_mico');


//get requirements
goog.require('lime.Director');
goog.require('lime.Scene');
goog.require('lime.Layer');
goog.require('lime.Circle');
goog.require('lime.Label');
goog.require('lime.animation.Spawn');
goog.require('lime.animation.FadeTo');
goog.require('lime.animation.ScaleTo');
goog.require('lime.animation.MoveTo');

goog.require('jogo_mico.tela_inicial');
goog.require('jogo_mico.tela_jogo');


// entrypoint
jogo_mico.start = function(){

	var director = new lime.Director(document.body,1024,768);
	var scene = new jogo_mico.tela_jogo();
	director.makeMobileWebAppCapable();

	// set current scene active
	director.replaceScene(scene);

}


//this is required for outside access after code is compiled in ADVANCED_COMPILATIONS mode
goog.exportSymbol('jogo_mico.start', jogo_mico.start);
