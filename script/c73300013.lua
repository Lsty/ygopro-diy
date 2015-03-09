--血符·恶女置乱
function c73300013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c73300013.target)
	e1:SetOperation(c73300013.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c73300013.descon)
	e2:SetTarget(c73300013.destg)
	e2:SetOperation(c73300013.desop)
	c:RegisterEffect(e2)
end
function c73300013.filter(c,e,tp)
	return c:IsSetCard(0x733) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c73300013.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsXyzSummonable(mg)
end
function c73300013.mfilter1(c,exg)
	return exg:IsExists(c73300013.mfilter2,1,nil,c)
end
function c73300013.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c73300013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c73300013.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.GetFlagEffect(tp,73300013)==0 and (not Duel.IsPlayerAffectedByEffect(tp,23516703) or c23516703[tp]==0)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c73300013.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c73300013.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c73300013.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	local exg2=exg:Filter(c73300013.mfilter2,nil,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c73300013.mfilter1,1,1,tc1,exg2)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
	Duel.RegisterFlagEffect(tp,73300013,RESET_PHASE+PHASE_END,0,1)
end
function c73300013.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c73300013.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,23516703) and c23516703[tp]>0 then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c73300013.filter2,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c73300013.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_END)
		xyz:RegisterEffect(e1)
	end
end
function c73300013.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEDOWN)~=0
end
function c73300013.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c73300013.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end