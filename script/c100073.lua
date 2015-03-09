--虹之转变
function c100073.initial_effect(c)
    c:SetUniqueOnField(1,0,100073)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--加上虹纹1次通常召唤，这个方法成功给指示物
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
    e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,(0xf70)))
    e2:SetValue(c100073.esop)
    c:RegisterEffect(e2)
	--②：检索加入手卡或特招
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(35419032,0))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMING_END_PHASE)
    e3:SetLabel(1)
	e3:SetCondition(c100073.spcon)
    e3:SetCost(c100073.cost2)
    e3:SetTarget(c100073.target2)
    e3:SetOperation(c100073.operation)
    c:RegisterEffect(e3)
	--虹纹指示物4个时触发
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_SZONE)
    e4:SetOperation(c100073.acop)
    c:RegisterEffect(e4)
	--③：破坏并失去3000LP
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(100073,0))
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e5:SetCode(100073)
    e5:SetTarget(c100073.damtg)
    e5:SetOperation(c100073.damop)
    c:RegisterEffect(e5)
end
function c100073.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsSetCard(0xf70) then
		Duel.RegisterFlagEffect(rp,100073,RESET_PHASE+PHASE_END,0,1)
	end
end
function c100073.esop(e,c)
    e:GetHandler():AddCounter(0x1b,1)
end
function c100073.dfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c100073.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100073.dfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c100073.cfilter(c)
    return c:IsSetCard(0xf70) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND+LOCATION_MZONE) or c:IsFaceup()) and c:IsAbleToRemoveAsCost() 
end
function c100073.afilter(c)
    return c:IsSetCard(0xf70) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100073.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c100073.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c100073.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    if g:GetFirst():IsLocation(LOCATION_HAND) then
        Duel.ConfirmCards(1-tp,g)
    end
    Duel.Remove(g,POS_FACEUP,nil,2,REASON_COST)
	if chk==0 then return Duel.GetFlagEffect(tp,100073)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(1,0)
    e1:SetValue(c100073.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c100073.splimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0xf70)
end
function c100073.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():GetFlagEffect(100073)==0
        and Duel.IsExistingMatchingCard(c100073.afilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    e:GetHandler():RegisterFlagEffect(100073,RESET_PHASE+PHASE_END,0,1)
end
function c100073.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100073.afilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(100073,0))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
			if e:GetHandler():IsRelateToEffect(e) then
		    e:GetHandler():AddCounter(0x1b,1)
	end
	end
end
function c100073.acop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
    local c=e:GetHandler()
    if c:GetCounter(0x1b)==4 then
        Duel.RaiseSingleEvent(c,100073,re,0,0,p,0)
    end
end
function c100073.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,ep,4000)
end
function c100073.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(ep,4000,REASON_EFFECT)
	end
end