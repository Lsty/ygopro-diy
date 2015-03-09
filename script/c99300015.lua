--秘封的境界少女 玛艾露贝莉·赫恩
function c99300015.initial_effect(c)
	c:SetUniqueOnField(1,0,99300015)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x993),aux.NonTuner(Card.IsSetCard,0x993),1)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c99300015.con)
	e1:SetTarget(c99300015.tg)
	e1:SetOperation(c99300015.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c99300015.chainfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99300015.chainfilter)
	c:RegisterEffect(e3)
	--destroy & damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c99300015.damcon)
	e4:SetTarget(c99300015.damtg)
	e4:SetOperation(c99300015.damop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_MSET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e6:SetCondition(c99300015.damcon)
	e6:SetTarget(c99300015.damtg)
	e6:SetOperation(c99300015.damop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SSET)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_CHANGE_POS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCondition(c99300015.damcon)
	e8:SetTarget(c99300015.damtg)
	e8:SetOperation(c99300015.damop)
	c:RegisterEffect(e8)
end
function c99300015.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c99300015.filter(c)
	return c:IsSetCard(0x993) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c99300015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99300015.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99300015.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99300015.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c99300015.chainfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSetCard(0x993)
end
function c99300015.dfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c99300015.damcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c99300015.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99300015.dfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
end
function c99300015.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99300015.dfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.ConfirmCards(tp,sg)
		local opt=Duel.SelectOption(tp,aux.Stringid(99300015,0),aux.Stringid(99300015,1))
		if opt==0 then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		else
			Duel.SendtoDeck(sg,nil,1,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end