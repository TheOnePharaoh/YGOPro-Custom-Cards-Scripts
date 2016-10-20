--Twilight Magus Lord Lancelot
function c55438820.initial_effect(c)
	--set fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c55438820.fcon)
	e1:SetOperation(c55438820.fop)
	c:RegisterEffect(e1)
	--Unaffected by Opponent Card Effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c55438820.unval)
	c:RegisterEffect(e2)
	--spsummon condition
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.fuslimit)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--double
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(c55438820.damcon)
	e5:SetOperation(c55438820.damop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(55438820,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetTarget(c55438820.destg)
	e6:SetOperation(c55438820.desop)
	c:RegisterEffect(e6)
	--special summon1
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(55438820,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_REMOVE)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,55438820)
	e7:SetTarget(c55438820.target1)
	e7:SetOperation(c55438820.operation1)
	c:RegisterEffect(e7)
	--special summon2
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(55438820,2))
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetCountLimit(1,55438820)
	e8:SetCondition(c55438820.condition)
	e8:SetTarget(c55438820.target2)
	e8:SetOperation(c55438820.operation2)
	c:RegisterEffect(e8)
end
function c55438820.ffilter1(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xd70)
end
function c55438820.ffilter2(c)
	return c:IsCode(55438799)
end
function c55438820.fcon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return (c55438820.ffilter1(gc) and mg:IsExists(c55438820.ffilter2,1,gc) and mg:IsExists(c55438820.ffilter1,1,gc)) 
			or (c55438820.ffilter2(gc) and mg:IsExists(c55438820.ffilter1,2,gc))
	end
	local g1=mg:Filter(c55438820.ffilter1,nil)
	local g2=mg:Filter(c55438820.ffilter2,nil)
	return g1:GetCount()>1 and g2:GetCount()>0
end
function c55438820.fop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		local sg=Group.CreateGroup()
		if c55438820.ffilter1(gc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(tp,c55438820.ffilter1,1,1,gc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g2=g:FilterSelect(tp,c55438820.ffilter2,1,1,gc)
			g1:Merge(g2)
			Duel.SetFusionMaterial(g1)
		end
		if c55438820.ffilter2(gc) then
			sg:Merge(g:Filter(c55438820.ffilter1,gc))
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=sg:Select(tp,2,2,nil)
			Duel.SetFusionMaterial(g1)
		end
		return
	end
	local sg2=g:Filter(c55438820.ffilter1,nil)
	local sg=g:Filter(c55438820.ffilter2,nil)
	sg:Merge(sg2)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else
		g1=sg:Select(tp,1,1,nil)
	end
	local tc=g1:GetFirst()
	if c55438820.ffilter1(tc) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=sg:FilterSelect(tp,c55438820.ffilter1,1,1,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g3=sg:FilterSelect(tp,c55438820.ffilter2,1,1,tc)
		g1:Merge(g2)
		g1:Merge(g3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=sg:FilterSelect(tp,c55438820.ffilter1,2,2,tc)
		g1:Merge(g2)
	end
	Duel.SetFusionMaterial(g1)
end
function c55438820.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c55438820.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil and e:GetHandler():GetBattleTarget():IsDefensePos()
end
function c55438820.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c55438820.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsSetCard(0xd70) and c:IsDestructable()
end
function c55438820.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438820.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c55438820.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c55438820.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c55438820.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c55438820.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end
function c55438820.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsLevelBelow(11) and not c:IsCode(55438820) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c55438820.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438820.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438820.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438820.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c55438820.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c55438820.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c55438820.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c55438820.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
