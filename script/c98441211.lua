--
function c98441211.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c98441211.fuscon)
	e1:SetOperation(c98441211.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c98441211.splimit)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98441211,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c98441211.condition)
	e3:SetTarget(c98441211.target)
	e3:SetOperation(c98441211.operation)
	c:RegisterEffect(e3)
	--untargetable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(c98441211.atlimit)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SELECT_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTargetRange(0,0xff)
	e5:SetValue(c98441211.tglimit)
	c:RegisterEffect(e5)
	--tohand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98441211,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetTarget(c98441211.thtg2)
	e6:SetOperation(c98441211.thop2)
	c:RegisterEffect(e6)
end
function c98441211.ffilter1(c)
	return c:IsSetCard(0x9d)
end
function c98441211.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_DEVINE) or c:IsHasEffect(4904633)
end
function c98441211.exfilter(c,g)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not g:IsContains(c)
end
function c98441211.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98441211.exfilter,tp,0,LOCATION_MZONE,nil,g)
		exg:Merge(sg)
	end
	if gc then return (c98441211.ffilter1(gc) and (g:IsExists(c98441211.ffilter2,1,gc) or exg:IsExists(c98441211.ffilter2,1,gc)))
		or (c98441211.ffilter2(gc) and (g:IsExists(c98441211.ffilter1,1,gc) or exg:IsExists(c98441211.ffilter1,1,gc))) end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local g3=Group.CreateGroup()
	local g4=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if c98441211.ffilter1(tc) then
			g1:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g3:AddCard(tc) end
		end
		if c98441211.ffilter2(tc) then
			g2:AddCard(tc)
			if aux.FConditionCheckF(tc,chkf) then g4:AddCard(tc) end
		end
		tc=g:GetNext()
	end
	local exg1=exg:Filter(c98441211.ffilter1,nil)
	local exg2=exg:Filter(c98441211.ffilter2,nil)
	if chkf~=PLAYER_NONE then
		return (g3:IsExists(aux.FConditionFilterF2,1,nil,g2)
			or g3:IsExists(aux.FConditionFilterF2,1,nil,exg2)
			or g4:IsExists(aux.FConditionFilterF2,1,nil,g1)
			or g4:IsExists(aux.FConditionFilterF2,1,nil,exg1))
	else
		return (g1:IsExists(aux.FConditionFilterF2,1,nil,g2)
			or g1:IsExists(aux.FConditionFilterF2,1,nil,exg2)
			or g2:IsExists(aux.FConditionFilterF2,1,nil,exg1))
	end
end
function c98441211.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=Group.CreateGroup()
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		local sg=Duel.GetMatchingGroup(c98441211.exfilter,tp,0,LOCATION_MZONE,nil,eg)
		exg:Merge(sg)
	end
	if gc then
		local sg1=Group.CreateGroup()
		local sg2=Group.CreateGroup()
		if c98441211.ffilter1(gc) then
			sg1:Merge(eg:Filter(c98441211.ffilter2,gc))
			sg2:Merge(exg:Filter(c98441211.ffilter2,gc))
		end
		if c98441211.ffilter2(gc) then
			sg1:Merge(eg:Filter(c98441211.ffilter1,gc))
			sg2:Merge(exg:Filter(c98441211.ffilter1,gc))
		end
		local g1=nil
		if sg1:GetCount()==0 or (sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0))) then
			fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g1=sg2:Select(tp,1,1,nil)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			g1=sg1:Select(tp,1,1,nil)
		end
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(aux.FConditionFilterF2c,nil,c98441211.ffilter1,c98441211.ffilter2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	local tc1=g1:GetFirst()
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	if c98441211.ffilter1(tc1) then
		sg1:Merge(sg:Filter(c98441211.ffilter2,tc1))
		sg2:Merge(exg:Filter(c98441211.ffilter2,tc1))
	end
	if c98441211.ffilter2(tc1) then
		sg1:Merge(sg:Filter(c98441211.ffilter1,tc1))
		sg2:Merge(exg:Filter(c98441211.ffilter1,tc1))
	end
	local g2=nil
	if sg1:GetCount()==0 or (sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0))) then
		fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2=sg2:Select(tp,1,1,nil)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g2=sg1:Select(tp,1,1,nil)
	end
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end
function c98441211.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c98441211.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsSetCard(0x9d) and tc:IsType(TYPE_FUSION) and bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c98441211.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c98441211.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c98441211.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x9d) and c~=e:GetHandler()
end
function c98441211.tglimit(e,re,c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x9d) and c~=e:GetHandler()
end
function c98441211.thadfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98441211.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98441211.thadfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98441211.thadfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98441211.thadfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98441211.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
