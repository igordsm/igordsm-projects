goog.provide('jogo_mico.tela_inicial');

goog.require('lime.Scene');
goog.require('lime.Layer');

jogo_mico.tela_inicial = function () {
    lime.Scene.call(this);
    
    var target = new lime.Layer().setPosition(512,384),
        circle = new lime.Circle().setSize(150,150).setFill(255,150,0),
        lbl = new lime.Label().setSize(160,50).setFontSize(30).setText('TOUCH ME!'),
        title = new lime.Label().setSize(800,70).setFontSize(60).setText('Now move me around!')
            .setOpacity(1).setPosition(512,80).setFontColor('#999').setFill(200,100,0,.1);


    //add circle and label to target object
    target.appendChild(circle);
    target.appendChild(lbl);

    //add target and title to the scene
    this.appendChild(target);
    this.appendChild(title);
};


goog.inherits(jogo_mico.tela_inicial, lime.Scene);

goog.exportSymbol('jogo_mico.tela_inicial', jogo_mico.tela_inicial);
