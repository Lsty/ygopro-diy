--怪异专家 贝木泥舟
function c59800037.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x598),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c59800037.con)
	e1:SetTarget(c59800037.tg)
	e1:SetOperation(c59800037.op)
	c:RegisterEffect(e1)
	--confirm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c59800037.target)
	e2:SetOperation(c59800037.operation)
	c:RegisterEffect(e2)
end
function c59800037.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c59800037.cfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c59800037.setfilter(c)
	return c:IsSetCard(0x598) and c:GetLevel()==3 and c:IsSSetable() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c59800037.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c59800037.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c59800037.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c59800037.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c59800037.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c59800037.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c59800037.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c59800037.filter(chkc) end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) and
		Duel.IsExistingTarget(c59800037.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
	Duel.SetTargetPlayer(1-tp)
end
function c59800037.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 or not Duel.IsExistingTarget(nil,tp,0,LOCATION_DECK,1,nil) then return end
	local res=e:GetLabel()
	local tg=Duel.GetDecktopGroup(1-tp,1)
	local tc=tg:GetFirst()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,1)
	if (res==0 and not tc:IsType(TYPE_MONSTER)) or (res==1 and not tc:IsType(TYPE_SPELL)) or (res==2 and not tc:IsType(TYPE_TRAP)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c59800037.filter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end