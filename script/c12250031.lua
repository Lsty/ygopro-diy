--Gosick·鲁帕吉列
function c12250031.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),4,2)
	c:EnableReviveLimit()
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c12250031.cost)
	e1:SetOperation(c12250031.operation)
	c:RegisterEffect(e1)
	--destroy & damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12250031.con)
	e5:SetCost(c12250031.setcost)
	e5:SetTarget(c12250031.settg)
	e5:SetOperation(c12250031.setop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c12250031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c12250031.tfilter(c,e,tp)
	return (c:IsSSetable() and (c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsSetCard(0x598) or c:IsCode(9791914) or c:IsCode(58132856))) or (c:IsMSetable(true,nil) and c:IsType(TYPE_MONSTER))
end
function c12250031.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local m=0
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_MSET) and not Duel.IsPlayerAffectedByEffect(1-e:GetHandler():GetControler(),EFFECT_CANNOT_SSET) then
			if Duel.GetMatchingGroupCount(c12250031.tfilter,1-tp,LOCATION_HAND,0,nil,e,1-tp)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,0)) then
				m=1
				local sc=Group.GetFirst(Duel.SelectMatchingCard(1-tp,c12250031.tfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp))
				if sc:IsType(TYPE_SPELL+TYPE_TRAP) then
					Duel.SSet(1-tp,sc)
				elseif (sc:IsSetCard(0x598) or sc:IsCode(9791914) or sc:IsCode(58132856)) and Duel.SelectYesNo(1-tp,aux.Stringid(12250003,1)) then
					Duel.SSet(1-tp,sc)
				else
					Duel.MSet(1-tp,sc,true,nil)
				end
			end
		end
		local atk=c:GetBaseAttack()
		if atk>(m*400) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk*3-m*800)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
		end
	end
end
function c12250031.con(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c12250031.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(12250031)==0 end
	e:GetHandler():RegisterFlagEffect(12250031,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12250031.setfilter(c,e)
	return c:IsFacedown() and c:IsLocation(LOCATION_ONFIELD)
end
function c12250031.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12250031.setfilter,1,nil,nil) end
	Duel.SetTargetCard(eg)
end
function c12250031.setop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(c12250031.setfilter,1,nil,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local res=Duel.SelectOption(tp,70,71,72)
	local tc=eg:GetFirst()
	local mg=Group.CreateGroup()
	local m=0
	while tc do
		if tc:IsLocation(LOCATION_ONFIELD) and tc:IsRelateToEffect(e) and tc:IsFacedown() then
			mg:AddCard(tc)
			if (res==0 and tc:IsType(TYPE_MONSTER)) or (res==1 and tc:IsType(TYPE_SPELL)) or (res==2 and tc:IsType(TYPE_TRAP)) then m=m+1 end
		end
		tc=eg:GetNext()
	end
	Duel.ConfirmCards(tp,mg)
	local c=e:GetHandler()
	if m~=0 then
		if c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end
end