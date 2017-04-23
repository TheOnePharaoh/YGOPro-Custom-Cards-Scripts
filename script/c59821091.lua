--CXyz Idol Master The Deity of Evil Kharmila
function c59821091.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c59821091.tg)
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--place pcard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(59821091,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,59821091)
	e2:SetCondition(c59821091.pencon)
	e2:SetTarget(c59821091.pentg)
	e2:SetOperation(c59821091.penop)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0x1073)
	c:RegisterEffect(e3)
	--to pzone
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c59821091.con)
	e4:SetOperation(c59821091.op)
	c:RegisterEffect(e4)
	--immune spell
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c59821091.imcon)
	e5:SetValue(c59821091.efilter)
	c:RegisterEffect(e5)
	--battle indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(c59821091.indes)
	c:RegisterEffect(e6)
	--recover
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(59821091,1))
	e7:SetCategory(CATEGORY_RECOVER)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EVENT_BATTLE_DAMAGE)
	e7:SetCondition(c59821091.reccon)
	e7:SetTarget(c59821091.rectg)
	e7:SetOperation(c59821091.recop)
	c:RegisterEffect(e7)
	--chain solving
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(59821091,2))
	e8:SetCategory(CATEGORY_DISABLE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAIN_SOLVING)
	e8:SetRange(LOCATION_PZONE)
	e8:SetCountLimit(1,59821091)
	e8:SetCondition(c59821091.negcon)
	e8:SetOperation(c59821091.negop)
	c:RegisterEffect(e8)
	--destroy1
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(59821091,4))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e9:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e9:SetCondition(c59821091.descon)
	e9:SetCost(c59821091.descost1)
	e9:SetTarget(c59821091.destg1)
	e9:SetOperation(c59821091.desop1)
	c:RegisterEffect(e9)
	--destroy2
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(59821091,5))
	e10:SetCategory(CATEGORY_DESTROY)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e10:SetCode(EVENT_BATTLE_DESTROYING)
	e10:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e10:SetProperty(0,EFFECT_FLAG2_XMDETACH)
	e10:SetCondition(c59821091.descon)
	e10:SetCost(c59821091.descost2)
	e10:SetTarget(c59821091.destg2)
	e10:SetOperation(c59821091.desop2)
	c:RegisterEffect(e10)
	--immune trap
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c59821091.imcon2)
	e5:SetValue(c59821091.efilter2)
	c:RegisterEffect(e5)
end
function c59821091.tg(e,c)
	return c:IsSetCard(0xa1a2) or c:IsCode(59821040) or c:IsCode(59821041) or c:IsCode(59821042) or c:IsCode(59821043) or c:IsCode(59821044) or c:IsCode(59821045) or c:IsCode(59821046) or c:IsCode(59821048) or c:IsCode(59821049) or c:IsCode(59821085)
end
function c59821091.penfilter4(c)
    return c:IsSetCard(0xa1a2)
end
function c59821091.pencon(e,tp,eg,ep,ev,re,r,rp)
    local seq=e:GetHandler():GetSequence()
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)==nil 
end
function c59821091.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c59821091.penfilter4,tp,LOCATION_EXTRA,0,1,nil) end
end
function c59821091.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c59821091.penfilter4,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then 
	    local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c59821091.penfilter1(c)
    return c:IsDestructable() and c:GetSequence()==6
end
function c59821091.penfilter2(c)
    return c:IsDestructable() and c:GetSequence()==7
end
function c59821091.con(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
    if not p1 and not p2 then return false end 
    return (e:GetHandler():IsReason(REASON_EFFECT) or e:GetHandler():IsReason(REASON_BATTLE)) and
	    (p1 and p1:IsDestructable()) or (p2 and p2:IsDestructable()) and e:GetHandler():GetPreviousLocation()==LOCATION_MZONE
end
function c59821091.op(e,tp,eg,ep,ev,re,r,rp)
    local p1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local p2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g1=nil
	local g2=nil
	if p1 then 
	    g1=Duel.GetMatchingGroup(c59821091.penfilter1,tp,LOCATION_SZONE,0,nil)
	end
	if p2 then 
	    g2=Duel.GetMatchingGroup(c59821091.penfilter2,tp,LOCATION_SZONE,0,nil)
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
function c59821091.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c59821091.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL)
end
function c59821091.indes(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c59821091.reccon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return false end
	local rc=eg:GetFirst()
	return rc:IsControler(tp) and rc:IsSetCard(0xa1a2) or rc:IsCode(59821041) or rc:IsCode(59821042) or rc:IsCode(59821043) or rc:IsCode(59821044) or rc:IsCode(59821039) or rc:IsCode(59821040) or rc:IsCode(59821041) or rc:IsCode(59821042) or rc:IsCode(59821043) or rc:IsCode(59821044) or rc:IsCode(59821045) or rc:IsCode(59821046) or rc:IsCode(59821048) or rc:IsCode(59821049) or rc:IsCode(59821085)
end
function c59821091.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c59821091.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c59821091.tfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa1a2) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c59821091.negcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)	
	return e:GetHandler():GetFlagEffect(59821091)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
		and g and g:IsExists(c59821091.tfilter,1,e:GetHandler(),tp) and Duel.IsChainDisablable(ev)
end
function c59821091.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(59821091,3)) then
		e:GetHandler():RegisterFlagEffect(59821091,RESET_EVENT+0x1fe0000,0,1)
		Duel.NegateEffect(ev)
		Duel.BreakEffect()
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
function c59821091.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c59821091.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c59821091.desfilter1(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c59821091.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821091.desfilter1,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c59821091.desfilter1,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c59821091.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c59821010.desfilter1,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c59821091.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c59821091.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c59821091.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c59821091.overlayfilter(c)
	return c:IsCode(59821010) or c:IsHasEffect(59821167)
end
function c59821091.imcon2(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c59821091.overlayfilter,1,nil)
end
function c59821091.efilter2(e,te)
	return e:GetHandlerPlayer()~=te:GetHandlerPlayer() and te:IsActiveType(TYPE_TRAP)
end