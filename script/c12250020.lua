--Gosick·路奇
function c12250020.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c12250020.target)
	e1:SetOperation(c12250020.operation)
	c:RegisterEffect(e1)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12250020.con)
	e5:SetCost(c12250020.setcost)
	e5:SetTarget(c12250020.settg)
	e5:SetOperation(c12250020.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c12250020.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local s=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,s)  end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,LOCATION_DECK)
end
function c12250020.tfilter(c,e,tp)
	return (c:IsSSetable() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x598) or c:IsCode(9791914) or c:IsCode(58132856))) or (c:IsMSetable(true,nil) and c:IsType(TYPE_MONSTER))
end
function c12250020.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_SSET) then
		if Duel.GetMatchingGroupCount(c12250020.tfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,0)) then
			local sc=Group.GetFirst(Duel.SelectMatchingCard(1-tp,c12250020.tfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp))
			if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
				Duel.SSet(1-tp,sc)
			elseif (sc:IsSetCard(0x598) or sc:IsCode(9791914) or sc:IsCode(58132856)) and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,1)) then
				Duel.SSet(1-tp,sc)
			else
				Duel.MSet(1-tp,sc,true,nil)
			end
			return
		end
	end
	local s=Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	Duel.Draw(tp,s,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.DiscardHand(tp,aux.TRUE,s,s,REASON_EFFECT+REASON_DISCARD)
end
function c12250020.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250020.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12250020)==0 end
	e:GetHandler():RegisterFlagEffect(12250020,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12250020.filter(c,e,tp)
	return c:IsSetCard(0x4c9) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12250020.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250020.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250020.setfilter,1,nil,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c12250020.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetTargetCard(eg)
end
function c12250020.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c12250020.filter,tp,LOCATION_HAND,0,1,nil,e,tp) then return end
	if not eg:IsExists(c12250020.setfilter,1,nil,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local sc=eg:GetFirst()
	local mg=Group.CreateGroup()
	local m=0
	while sc do
		if sc:IsLocation(LOCATION_ONFIELD) and sc:IsRelateToEffect(e) and sc:IsFacedown() then
			mg:AddCard(sc)
			if (res==0 and sc:IsType(TYPE_MONSTER)) or (res==1 and sc:IsType(TYPE_SPELL)) or (res==2 and sc:IsType(TYPE_TRAP)) then m=m+1 end
		end
		sc=eg:GetNext()
	end
	Duel.ConfirmCards(tp,mg)
	if m~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12250020.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end