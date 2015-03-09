--时符·咲夜特制计秒表
function c98700018.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CHAIN_UNIQUE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c98700018.condition)
	e1:SetCost(c98700018.cost)
	e1:SetTarget(c98700018.target)
	e1:SetOperation(c98700018.activate)
	c:RegisterEffect(e1)
end
function c98700018.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_TRAP)
end
function c98700018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98700018)==0 end
	Duel.RegisterFlagEffect(tp,98700018,RESET_PHASE+PHASE_END,0,1)
end
function c98700018.spfilter(c,e,tp)
	return c:IsSetCard(0x987) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98700018.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (Duel.GetCurrentChain()<1 or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c98700018.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if Duel.GetCurrentChain()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectTarget(tp,c98700018.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		e:SetLabelObject(g1:GetFirst())
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c98700018.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc1==tc then tc=g:GetNext() end
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		e1:SetCountLimit(1)
		e1:SetOperation(c98700018.desop)
		tc:RegisterEffect(e1)
	end
	local ct=Duel.GetCurrentChain()
	if ct>=2 and tc1:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENCE)
	end
end
function c98700018.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
end