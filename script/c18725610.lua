--獅心王 立华奏
function c18725610.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x266),4,2)
	c:EnableReviveLimit()
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c18725610.atkval)
	e3:SetCondition(c18725610.effcon)
	e3:SetLabel(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENCE)
	c:RegisterEffect(e4)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83986578,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c18725610.condition)
	e1:SetTarget(c18725610.target)
	e1:SetOperation(c18725610.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--remove material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(31386180,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c18725610.rmcon)
	e5:SetOperation(c18725610.rmop)
	c:RegisterEffect(e5)
end
function c18725610.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function c18725610.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),LOCATION_MZONE,1)*300
end
function c18725610.cfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(1500) and not c:IsType(TYPE_TOKEN)
end
function c18725610.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c18725610.cfilter,1,nil) and not eg:IsContains(e:GetHandler()) and e:GetHandler():GetOverlayCount()>0
end
function c18725610.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c18725610.cfilter,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c18725610.filter(c,e)
	return c:IsFaceup() and c:IsAttackBelow(1500) and c:IsRelateToEffect(e)
end
function c18725610.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c18725610.filter,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c18725610.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c18725610.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end