--侵蚀现世的时幻结界
function c127508.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7fa))
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c127508.value)
	c:RegisterEffect(e2)
	--sarch
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c127508.drcon)
	e3:SetTarget(c127508.target)
	e3:SetOperation(c127508.activate)
	c:RegisterEffect(e3)
end 
function c127508.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7fa) 
end
function c127508.value(e,c)
	return Duel.GetMatchingGroupCount(c127508.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*100
end
function c127508.filter(c)
	return c:IsSetCard(0x7fa) and c:IsType(TYPE_MONSTER)
end
function c127508.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return  eg:IsExists(c127508.filter,1,nil) and tc:GetControler()==tp 
end
function c127508.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<2 then return false end
		local g=Duel.GetDecktopGroup(tp,2)
		local result=g:FilterCount(Card.IsAbleToHand,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c127508.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,2)
	local g=Duel.GetDecktopGroup(p,2)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
	end
end	
