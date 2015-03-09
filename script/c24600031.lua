--零崎人识的人间关系
function c24600031.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c24600031.cost)
	e1:SetTarget(c24600031.destg)
	e1:SetOperation(c24600031.desop)
	c:RegisterEffect(e1)
end
function c24600031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,24600031)==0 end
	Duel.RegisterFlagEffect(tp,24600031,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c24600031.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x246) and c:IsAbleToHand()
end
function c24600031.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x246)
end
function c24600031.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24600031.filter1,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(c24600031.filter2,tp,LOCATION_MZONE,0,1,nil) end
	local t={}
	local p=1
	if Duel.IsExistingMatchingCard(c24600031.filter1,tp,LOCATION_DECK,0,1,nil) then t[p]=aux.Stringid(24600031,0) p=p+1 end
	if Duel.IsExistingMatchingCard(c24600031.filter2,tp,LOCATION_MZONE,0,1,nil) then t[p]=aux.Stringid(24600031,1) p=p+1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(24600031,2))
	local sel=Duel.SelectOption(tp,table.unpack(t))+1
	local opt=t[sel]-aux.Stringid(24600031,0)
	local sg=nil
	if opt==0 then e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	e:SetLabel(opt)
end
function c24600031.desop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	local sg=nil
	if opt==0 then 
	Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_TOHAND)
	local sg=Duel.SelectMatchingCard(tp,c24600031.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	else
		local g=Duel.GetMatchingGroup(c24600031.filter2,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
			e1:SetValue(c24600031.efilter)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
function c24600031.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end