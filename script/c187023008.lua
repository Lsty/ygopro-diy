--NBIRD
function c187023008.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WINDBEAST),1)
	c:EnableReviveLimit()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93717133,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c187023008.rmcon)
	e2:SetTarget(c187023008.rmtg)
	e2:SetOperation(c187023008.rmop)
	c:RegisterEffect(e2)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c187023008.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23015896,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c187023008.spcon)
	e3:SetTarget(c187023008.sptg)
	e3:SetOperation(c187023008.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c187023008.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c187023008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsOnField() and bc:IsCanBeEffectTarget(e) and c:IsAbleToRemove() and bc:IsAbleToRemove() end
	Duel.SetTargetCard(bc)
	local g=Group.FromCards(c,bc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function c187023008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
    if g:GetCount()>0 then
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c187023008.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler():IsSetCard(0x257) then return end
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(187023008,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(187023008,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,1)
	end
end
function c187023008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(187023008)>0
end
function c187023008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(187023008)
end
function c187023008.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,257,tp,tp,false,false,POS_FACEUP)
	end
end
