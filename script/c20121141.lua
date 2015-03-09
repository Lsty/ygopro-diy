--★绝境的重生
function c20121141.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20121141.condition)
	e1:SetCost(c20121141.cost)
	e1:SetTarget(c20121141.target)
	e1:SetOperation(c20121141.activate)
	c:RegisterEffect(e1)
end
function c20121141.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c20121141.filter(c,e,tp)
	return c:IsSetCard(0x777) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20121141.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c20121141.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c20121141.filter,tp,LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return mg:GetCount()>0 and Duel.IsExistingTarget(c20121141.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c20121141.filter,tp,LOCATION_REMOVED,0,1,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c20121141.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()==0 then return end
	local tg=sg:GetFirst()
	while tg do
		if Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
			tg:RegisterFlagEffect(20121141,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		tg=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	sg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c20121141.desop)
	e1:SetLabelObject(sg)
	Duel.RegisterEffect(e1,tp)
end
function c20121141.desfilter(c)
	return c:GetFlagEffect(20121141)>0
end
function c20121141.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	local dg=sg:Filter(c20121141.desfilter,nil)
	sg:DeleteGroup()
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
end
