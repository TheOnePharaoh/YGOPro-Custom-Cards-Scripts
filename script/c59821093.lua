--Triple as One
function c59821093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCountLimit(1,59821093)
	e1:SetCondition(c59821093.condition)
	e1:SetCost(c59821093.cost)
	e1:SetTarget(c59821093.target)
	e1:SetOperation(c59821093.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821093,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(c59821093.drcon)
	e2:SetTarget(c59821093.drtg)
	e2:SetOperation(c59821093.drop)
	c:RegisterEffect(e2)
	--xyz restrict
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c59821093.extralimit)
	c:RegisterEffect(e3)
	--synchro restrict
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(c59821093.extralimit)
	c:RegisterEffect(e4)
	--fusion restrict
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c59821093.extralimit)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(59821093,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(c59821093.spcon)
	e6:SetTarget(c59821093.sptg)
	e6:SetOperation(c59821093.spop)
	c:RegisterEffect(e6)	
	if not c59821093.global_check then
		c59821093.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,59821093))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c59821093.extralimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xa1a2)
end

function c59821093.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()<PHASE_MAIN2
end
function c59821093.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,3)
	Duel.RegisterEffect(e1,tp)
end
function c59821093.filter(c,e)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsSetCard(0xa1a2) and c:IsType(TYPE_PENDULUM) and c:IsCanBeEffectTarget(e)
end
function c59821093.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsXyzSummonable(mg)
end
function c59821093.mfilter1(c,exg)
	return exg:IsExists(c59821093.mfilter2,1,nil,c)
end
function c59821093.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c59821093.mfilter3(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c59821093.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c59821093.filter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and mg:GetCount()>1
		and Duel.IsExistingMatchingCard(c59821093.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c59821093.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=mg:FilterSelect(tp,c59821093.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg2=mg:FilterSelect(tp,c59821093.mfilter3,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c59821093.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<2 then return end
	local xyzg=Duel.GetMatchingGroup(c59821093.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c59821093.splimit)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c59821093.splimit(e,c)
	return not c:IsSetCard(0xa1a2)
end
function c59821093.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ep==tp and ec:IsSetCard(0xa1a2) and ec:IsLevelBelow(4) and ec:IsType(TYPE_PENDULUM)
end
function c59821093.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,ec:GetCode(),0,0xa1a2,ec:GetLevel(),ec:GetAttack(),ec:GetDefense(),ec:GetRace(),ec:GetAttribute()) end
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c59821093.spop(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	if not ec:IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,ec:GetCode(),0,0xa1a2,ec:GetLevel(),ec:GetAttack(),ec:GetDefense(),ec:GetRace(),ec:GetAttribute()) then return end
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(ec:GetCode())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e2:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(ec:GetLevel())
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)
		e4:SetValue(ec:GetAttack())
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e5:SetValue(ec:GetDefense())
		e5:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CHANGE_RACE)
		e6:SetValue(ec:GetRace())
		e6:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e6,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetReset(RESET_EVENT+0x47e0000)
		e7:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e7,true)
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e8:SetValue(ec:GetAttribute())
		e8:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e8,true)
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e9:SetValue(1)
		e9:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e9,true)
		local e10=e9:Clone()
		e10:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		c:RegisterEffect(e10,true)
end
function c59821093.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821093.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
end
function c59821093.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end