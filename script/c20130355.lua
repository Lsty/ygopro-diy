--冥界人 涅古蕾莉亚·涅比洛丝
function c20130355.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c20130355.spcon)
	e1:SetOperation(c20130355.spop1)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c20130355.sptg)
	e2:SetOperation(c20130355.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--return to deck
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1c0)
	e4:SetCost(c20130355.cost)
	e4:SetTarget(c20130355.target)
	e4:SetOperation(c20130355.operation)
	c:RegisterEffect(e4)
end
function c20130355.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsCode,2,nil,20130324)
end
function c20130355.spop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,2,2,nil,20130324)
	Duel.Release(g,REASON_COST)
end
function c20130355.ctfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c20130355.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetMatchingGroupCount(c20130355.ctfilter,tp,LOCATION_MZONE,0,e:GetHandler())>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,20130325,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c20130355.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetMatchingGroupCount(c20130355.ctfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if ft>ct then ft=ct end
	if ft<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,20130325,0,0x4011,0,0,2,RACE_FIEND,ATTRIBUTE_LIGHT) then return end
	local ctn=true
	while ft>0 and ctn do
		local token=Duel.CreateToken(tp,20130325)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c20130355.sumlimit)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		ft=ft-1
		if ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(20130355,0)) then ctn=false end
	end
	Duel.SpecialSummonComplete()
end
function c20130355.sumlimit(e,c)
	return not c:IsRace(RACE_FIEND)
end
function c20130355.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsCode,2,nil,20130324) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,2,2,nil,20130324)
	Duel.Release(g,REASON_COST)
end
function c20130355.filter(c)
	return c:IsAbleToDeck() and c:IsFaceup()
end
function c20130355.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c20130355.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20130355.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c20130355.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c20130355.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end