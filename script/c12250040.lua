--妖精高塔
function c12250040.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12250040.target)
	e1:SetOperation(c12250040.activate)
	c:RegisterEffect(e1)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CHAIN_UNIQUE)
	e5:SetCode(EVENT_MSET)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c12250040.con)
	e5:SetCost(c12250040.setcost)
	e5:SetTarget(c12250040.settg)
	e5:SetOperation(c12250040.setop)
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
function c12250040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12250040.tfilter(c,e,tp)
	return (c:IsSSetable() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x598) or c:IsCode(9791914) or c:IsCode(58132856))) or (c:IsMSetable(true,nil) and c:IsType(TYPE_MONSTER))
end
function c12250040.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_SZONE) then return end
	if Duel.IsChainDisablable(0) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_SSET) then
		if Duel.GetMatchingGroupCount(c12250040.tfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,0)) then
			local sc=Group.GetFirst(Duel.SelectMatchingCard(1-tp,c12250040.tfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp))
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
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c12250040.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250040.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12250040)==0 end
	e:GetHandler():RegisterFlagEffect(12250040,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12250040.sfilter(c,e,tp)
	return c:IsCode(12250001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c12250040.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250040.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250040.setfilter,1,nil,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c12250040.sfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetTargetCard(eg)
end
function c12250040.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_SZONE) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsExistingMatchingCard(c12250040.sfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) then return end
	if not eg:IsExists(c12250040.setfilter,1,nil,nil) then return end
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
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12250040.sfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
