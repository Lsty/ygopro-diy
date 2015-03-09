--危险的魔术师 十六夜咲夜
function c98700004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c98700004.spcon)
	e1:SetTarget(c98700004.sptg)
	e1:SetOperation(c98700004.spop)
	c:RegisterEffect(e1)
end
function c98700004.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:GetActiveType()==TYPE_SPELL+TYPE_QUICKPLAY and re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:GetHandler():IsSetCard(0x986)
end
function c98700004.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x987) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98700004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98700004.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e)
		and e:GetHandler():IsFaceup() and Duel.IsExistingTarget(c98700004.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c98700004.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98700004.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(98700004,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.SpecialSummonComplete()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c98700004.desop)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98700004.desfilter(c)
	return c:GetFlagEffect(98700004)>0
end
function c98700004.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if sg:GetFlagEffect(98700004)>0 then
		local at1=sg:GetBaseAttack()
		Duel.Destroy(sg,REASON_EFFECT)
		if at1~=0 then Duel.Damage(tp,at1,REASON_EFFECT) end
	end
end