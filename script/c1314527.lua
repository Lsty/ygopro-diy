--夜夜 光焰绝冲:月影红莲
function c1314527.initial_effect(c)
	c:EnableReviveLimit()
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314527,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0x1000000,0x1e0)
	e1:SetRange(0x2)
	e1:SetCost(c1314527.cost)
	e1:SetOperation(c1314527.operation)
	c:RegisterEffect(e1)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1314527,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1314527)
	e1:SetCondition(c1314527.remcon)
	e1:SetOperation(c1314527.activate)
	c:RegisterEffect(e1)
end 
function c1314527.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.CheckLPCost(tp,500) end
	Duel.Remove(e:GetHandler(),0x5,0x80) 
	Duel.PayLPCost(tp,500) 
end
function c1314527.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(0x4,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end
function c1314527.remcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c1314527.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c1314527.regcon)
	e1:SetOperation(c1314527.regop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c1314527.effcon)
	e3:SetOperation(c1314527.effop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	e1:SetLabelObject(e3)
end
function c1314527.tfilter(c)
	return c:GetLevel()>=5 and c:IsSetCard(0x9fd)
end
function c1314527.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1314527.tfilter,1,nil)
end
function c1314527.regop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(ct+1)
end
function c1314527.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function c1314527.sfilter(c)
	return c:IsSetCard(0x9fd) or c:IsSetCard(0x9ff) and c:IsAbleToHand()
end
function c1314527.effop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1,1314527)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1314527.sfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,e:GetLabel(),nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end