--时幻武神姬 森之黑山羊
function c127510.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(Card.IsSetCard,0x7fa),1)
	c:EnableReviveLimit()
	--cannot trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c127510.condition)
	e1:SetValue(c127510.value)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	--pierce 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
end
function c127510.condition(e)
	return  Duel.GetCurrentPhase()==PHASE_BATTLE 
end
function c127510.value(e,re,rp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
