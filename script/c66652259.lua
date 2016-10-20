--Twisted Vocaloid Violator of the Another Dimension
function c66652259.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c66652259.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c66652259.atktg)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--place pcard
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c66652259.pencon)
	e4:SetCost(c66652259.pencost)
	e4:SetTarget(c66652259.pentg)
	e4:SetOperation(c66652259.penop)
	c:RegisterEffect(e4)
	--atk change
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c66652259.adval)
	c:RegisterEffect(e5)
	--effect gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCondition(c66652259.effectcon)
	e6:SetOperation(c66652259.effectop)
	c:RegisterEffect(e6)
	--to pzone
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c66652259.con)
	e7:SetOperation(c66652259.op)
	c:RegisterEffect(e7)
end
function c66652259.atktg(e,c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x0dac403)
end
function c66652259.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c66652259.penfilter4(c)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function c66652259.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c66652259.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c66652259.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil) end
end
function c66652259.penop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c66652259.penfilter4,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c66652259.atkchangefilter(c)
	return c:IsFaceup() and c:GetCode()~=66652259
end
function c66652259.adval(e,c)
	local g=Duel.GetMatchingGroup(c66652259.atkchangefilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()==0 then 
		return 500
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val+500
	end
end
function c66652259.effectcon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+560) and st<(SUMMON_TYPE_SPECIAL+570)
end
function c66652259.effectop(e,tp,eg,ep,ev,re,r,rp)
	--immune
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c66652259.immfilter)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c66652259.damcon)
	e2:SetTarget(c66652259.damtg)
	e2:SetOperation(c66652259.damop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e2)
end
function c66652259.immfilter(e,te)
	if te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	if te:IsActiveType(TYPE_MONSTER) and (te:IsHasType(0x7e0) or te:IsHasProperty(EFFECT_FLAG_FIELD_ONLY) or te:IsHasProperty(EFFECT_FLAG_OWNER_RELATE)) then
		local lv=e:GetHandler():GetLevel()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<lv
		else
			return ec:GetOriginalLevel()<lv
		end
	end
	return false
end
function c66652259.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c66652259.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c66652259.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
function c66652259.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c66652259.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c66652259.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c66652259.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c66652259.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c66652259.penfilter2,tp,LOCATION_SZONE,0,nil)
		if g1 then 
		    g1:Merge(g2)
		else 
		    g1=g2
		end
	end
	if g1 and Duel.Destroy(g1,REASON_EFFECT)~=0 then 
	        local c=e:GetHandler()	
	        Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end 
end