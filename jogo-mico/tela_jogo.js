goog.provide('jogo_mico.tela_jogo');

goog.require('lime.Scene');
goog.require('lime.Layer');
goog.require('lime.Label');

jogo_mico.tela_jogo = function () {
    lime.Scene.call(this);
    var title = new lime.Label().setSize(800,70).setFontSize(60).setText('JOGO').setPosition(512,80).setFontColor('#999').setFill(200,100,0,.1);
    this.appendChild(title);
};

goog.inherits(jogo_mico.tela_jogo, lime.Scene);

goog.exportSymbol('jogo_mico.tela_jogo', jogo_mico.tela_jogo);
