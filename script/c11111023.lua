--光暗一体
function c11111023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c11111023.cost)
	e1:SetTarget(c11111023.target)
	e1:SetOperation(c11111023.activate)
	c:RegisterEffect(e1)
end
function c11111023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,11111023)==0 end
	Duel.RegisterFlagEffect(tp,11111023,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c11111023.cfilter(c,e,tp)
	return c:GetLevel()==4 and c:IsFaceup() and Duel.IsExistingMatchingCard(c11111023.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c11111023.spfilter(c,e,tp)
	return c:GetLevel()==2 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11111023.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c11111023.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11111023.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11111023.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11111023.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local sc=Duel.GetFirstTarget()
	if sc:IsRelateToEffect(e) and sc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c11111023.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
	    local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		--cannot release
	    local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_UNRELEASABLE_SUM)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3,true)
     	local e4=e3:Clone()
		e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		tc:RegisterEffect(e4,true)
		--unsynchroable
	    local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5,true)
		--self destroy
	    local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetOperation(c11111023.desop)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e6:SetCountLimit(1)
		tc:RegisterEffect(e6)
		Duel.SpecialSummonComplete()
	end
end	
function c11111023.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end