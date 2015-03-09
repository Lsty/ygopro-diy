--镜现诗·水难事故的念缚灵
function c19300048.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c19300048.con)
	e1:SetCost(c19300048.cost)
	e1:SetTarget(c19300048.tg)
	e1:SetOperation(c19300048.op)
	c:RegisterEffect(e1)
end
function c19300048.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c19300048.cffilter(c)
	return c:IsSetCard(0x193) and not c:IsPublic()
end
function c19300048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if chk==0 then return c>0 and Duel.IsExistingMatchingCard(c19300048.cffilter,tp,LOCATION_HAND,0,1,nil) end
	if c>3 then c=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c19300048.cffilter,tp,LOCATION_HAND,0,1,c,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetCount())
end
function c19300048.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	local dis=Duel.SelectDisableField(tp,e:GetLabel(),LOCATION_ONFIELD,LOCATION_ONFIELD,0)
	e:SetLabel(dis)
end
function c19300048.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c19300048.disop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetLabel(e:GetLabel())
	e:GetHandler():RegisterEffect(e1)
end
function c19300048.disop(e,tp)
	return e:GetLabel()
end