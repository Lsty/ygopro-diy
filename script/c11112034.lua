--贪食的恐王 恐暴龙
function c11112034.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x15b),2)
	c:EnableReviveLimit()
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11112034,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c11112034.target)
	e1:SetOperation(c11112034.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(c11112034.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11112034,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c11112034.spcon)
	e3:SetCost(c11112034.spcost)
	e3:SetTarget(c11112034.sptg)
	e3:SetOperation(c11112034.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c11112034.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c11112034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
	    and Duel.IsExistingMatchingCard(c11112034.filter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c11112034.filter,tp,0,LOCATION_MZONE,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end	
function c11112034.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11112034.filter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	    Duel.DiscardDeck(tp,2,REASON_EFFECT)
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.Destroy(sg,REASON_EFFECT)~=0 then
			    Duel.BreakEffect()
				local e1=Effect.CreateEffect(c)
		        e1:SetType(EFFECT_TYPE_SINGLE)
		        e1:SetCode(EFFECT_UPDATE_ATTACK)
		        e1:SetValue(sg:GetFirst():GetAttack()/2)
		        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_END)
		        c:RegisterEffect(e1)
			end
		else 
		    if c:IsFaceup() and c:IsRelateToEffect(e) and Duel.Destroy(tg,REASON_EFFECT)~=0 then
			    Duel.BreakEffect()
				local e1=Effect.CreateEffect(c)
		        e1:SetType(EFFECT_TYPE_SINGLE)
		        e1:SetCode(EFFECT_UPDATE_ATTACK)
		        e1:SetValue(tg:GetFirst():GetAttack()/2)
		        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_END)
		        c:RegisterEffect(e1)
			end
		end	
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c11112034.val)
	e1:SetReset(RESET_PHASE+RESET_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c11112034.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
function c11112034.spreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsReason(REASON_DESTROY) then return end
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(11112034,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(11112034,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,1)
	end
end
function c11112034.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(11112034)>0
end
function c11112034.spfilter(c)
	return c:IsSetCard(0x15b) and c:IsAbleToRemoveAsCost()
end
function c11112034.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11112034.spfilter,tp,LOCATION_GRAVE,0,4,e:GetHandler()) end
	local g=Duel.SelectMatchingCard(tp,c11112034.spfilter,tp,LOCATION_GRAVE,0,4,4,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end
function c11112034.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(11112034)
end
function c11112034.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end